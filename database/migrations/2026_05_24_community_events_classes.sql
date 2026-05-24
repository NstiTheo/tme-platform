USE tme_platform;

ALTER TABLE posts
    ADD COLUMN IF NOT EXISTS post_type ENUM('duvida', 'artigo', 'projeto', 'material', 'conquista', 'aviso') NOT NULL DEFAULT 'duvida' AFTER user_id,
    ADD COLUMN IF NOT EXISTS is_featured TINYINT(1) NOT NULL DEFAULT 0 AFTER status,
    ADD COLUMN IF NOT EXISTS moderation_reason VARCHAR(255) NULL AFTER is_featured,
    ADD COLUMN IF NOT EXISTS moderated_by BIGINT UNSIGNED NULL AFTER moderation_reason,
    ADD COLUMN IF NOT EXISTS moderated_at TIMESTAMP NULL AFTER moderated_by,
    ADD COLUMN IF NOT EXISTS archived_at TIMESTAMP NULL AFTER moderated_at;

ALTER TABLE posts
    MODIFY status ENUM('pendente', 'aprovado', 'recusado', 'arquivado') NOT NULL DEFAULT 'pendente';

CREATE INDEX IF NOT EXISTS posts_status_index ON posts (status);
CREATE INDEX IF NOT EXISTS posts_featured_index ON posts (is_featured);
CREATE INDEX IF NOT EXISTS posts_type_index ON posts (post_type);

ALTER TABLE comments
    MODIFY status ENUM('pendente', 'aprovado', 'recusado', 'arquivado') NOT NULL DEFAULT 'aprovado';

CREATE TABLE IF NOT EXISTS post_likes (
    post_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, user_id),
    CONSTRAINT fk_post_likes_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_post_likes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS post_saves (
    post_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, user_id),
    CONSTRAINT fk_post_saves_post FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    CONSTRAINT fk_post_saves_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE events
    MODIFY event_type ENUM('palestra', 'workshop', 'aula_ao_vivo', 'simulado', 'olimpiada', 'hackathon', 'outro') NOT NULL DEFAULT 'palestra',
    ADD COLUMN IF NOT EXISTS capacity INT UNSIGNED NULL AFTER meeting_url,
    ADD COLUMN IF NOT EXISTS workload_hours SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER capacity,
    ADD COLUMN IF NOT EXISTS image_path VARCHAR(255) NULL AFTER workload_hours;

CREATE TABLE IF NOT EXISTS event_registrations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('inscrito', 'confirmado', 'cancelado') NOT NULL DEFAULT 'inscrito',
    registered_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    attended_at TIMESTAMP NULL,
    certificate_id BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY event_registrations_event_user_unique (event_id, user_id),
    KEY event_registrations_status_index (status),
    CONSTRAINT fk_event_registrations_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT fk_event_registrations_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_event_registrations_certificate FOREIGN KEY (certificate_id) REFERENCES certificates(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE certificates
    ADD COLUMN IF NOT EXISTS event_registration_id BIGINT UNSIGNED NULL AFTER enrollment_id;

CREATE UNIQUE INDEX IF NOT EXISTS certificates_event_registration_unique ON certificates (event_registration_id);

ALTER TABLE classes
    ADD COLUMN IF NOT EXISTS period VARCHAR(80) NULL AFTER description,
    ADD COLUMN IF NOT EXISTS status ENUM('ativa', 'inativa', 'arquivada') NOT NULL DEFAULT 'ativa' AFTER period;

ALTER TABLE subjects
    ADD COLUMN IF NOT EXISTS area VARCHAR(120) NULL AFTER description,
    ADD COLUMN IF NOT EXISTS status ENUM('ativa', 'inativa', 'arquivada') NOT NULL DEFAULT 'ativa' AFTER workload_hours;

CREATE TABLE IF NOT EXISTS class_students (
    class_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    linked_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (class_id, user_id),
    CONSTRAINT fk_class_students_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    CONSTRAINT fk_class_students_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS class_teachers (
    class_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    linked_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (class_id, user_id),
    CONSTRAINT fk_class_teachers_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    CONSTRAINT fk_class_teachers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS class_subjects (
    class_id BIGINT UNSIGNED NOT NULL,
    subject_id BIGINT UNSIGNED NOT NULL,
    teacher_id BIGINT UNSIGNED NULL,
    status ENUM('ativa', 'inativa') NOT NULL DEFAULT 'ativa',
    linked_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (class_id, subject_id),
    CONSTRAINT fk_class_subjects_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    CONSTRAINT fk_class_subjects_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    CONSTRAINT fk_class_subjects_teacher FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS subject_teachers (
    subject_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    linked_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (subject_id, user_id),
    CONSTRAINT fk_subject_teachers_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    CONSTRAINT fk_subject_teachers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
