<?php

defined('BASE_PATH') || exit('Acesso direto nao permitido.');

class CertificateService
{
    private Certificate $certificates;
    private Enrollment $enrollments;
    private ActionLog $logs;
    private GamificationService $gamification;

    public function __construct()
    {
        $this->certificates = new Certificate();
        $this->enrollments = new Enrollment();
        $this->logs = new ActionLog();
        $this->gamification = new GamificationService();
    }

    public function issueForEnrollment(int $enrollmentId): ?array
    {
        $existing = $this->certificates->findByEnrollment($enrollmentId);

        if ($existing) {
            return $existing;
        }

        $enrollment = $this->enrollments->find($enrollmentId);

        if (
            ! $enrollment ||
            $enrollment['status'] !== 'concluida' ||
            (float) $enrollment['progress_percent'] < 100
        ) {
            return null;
        }

        $certificateId = $this->certificates->createCourseCertificate([
            'user_id' => (int) $enrollment['user_id'],
            'enrollment_id' => $enrollmentId,
            'course_id' => (int) $enrollment['course_id'],
            'code' => $this->uniqueCode(),
            'title' => 'Certificado de conclusao - ' . $enrollment['course_title'],
            'workload_hours' => (int) $enrollment['workload_hours'],
        ]);

        $certificate = $this->certificates->find($certificateId);
        $this->logs->record((int) $enrollment['user_id'], 'certificate.issued', [
            'certificate_id' => $certificateId,
            'enrollment_id' => $enrollmentId,
            'course_id' => (int) $enrollment['course_id'],
            'code' => $certificate['code'] ?? null,
        ]);

        $this->gamification->certificateIssued((int) $enrollment['user_id'], $certificateId, (int) $enrollment['course_id']);

        return $certificate;
    }

    private function uniqueCode(): string
    {
        do {
            $code = 'TME-CUR-' . date('Y') . '-' . strtoupper(bin2hex(random_bytes(4)));
        } while ($this->certificates->findByCode($code));

        return $code;
    }
}
