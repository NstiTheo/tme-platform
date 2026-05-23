<?php

defined('BASE_PATH') || exit('Acesso direto nao permitido.');

class CourseCatalogController extends Controller
{
    private Course $courses;

    public function __construct()
    {
        $this->courses = new Course();
    }

    public function index(): void
    {
        $this->view('courses/index', [
            'title' => 'Cursos disponíveis',
            'courses' => $this->courses->published(),
        ]);
    }

    public function show(string $id): void
    {
        $course = $this->courses->findPublished((int) $id);

        if (! $course) {
            flash('error', 'Curso não encontrado ou indisponível.');
            $this->redirect('/aluno/cursos');
        }

        $this->view('courses/show', [
            'title' => $course['title'],
            'course' => $course,
            'structure' => $this->courses->structure((int) $course['id']),
        ]);
    }
}
