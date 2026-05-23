USE tme_platform;

ALTER TABLE activities
    ADD COLUMN IF NOT EXISTS module_id BIGINT UNSIGNED NULL AFTER course_id,
    ADD COLUMN IF NOT EXISTS lesson_id BIGINT UNSIGNED NULL AFTER module_id,
    ADD COLUMN IF NOT EXISTS instructions LONGTEXT NULL AFTER description,
    ADD COLUMN IF NOT EXISTS allow_late TINYINT(1) NOT NULL DEFAULT 1 AFTER max_score,
    ADD COLUMN IF NOT EXISTS attachment_path VARCHAR(255) NULL AFTER allow_late;

ALTER TABLE activities
    MODIFY activity_type ENUM('texto', 'arquivo', 'quiz', 'tarefa_pratica', 'projeto', 'atividade', 'prova', 'forum') NOT NULL DEFAULT 'texto';

CREATE INDEX IF NOT EXISTS activities_status_index ON activities (status);
CREATE INDEX IF NOT EXISTS activities_due_index ON activities (due_at);
CREATE INDEX IF NOT EXISTS activities_module_index ON activities (module_id);
CREATE INDEX IF NOT EXISTS activities_lesson_index ON activities (lesson_id);

ALTER TABLE submissions
    MODIFY status ENUM('pendente', 'enviada', 'atrasada', 'corrigida', 'devolvida') NOT NULL DEFAULT 'enviada';

CREATE UNIQUE INDEX IF NOT EXISTS submissions_activity_student_unique ON submissions (activity_id, student_id);
CREATE INDEX IF NOT EXISTS submissions_status_index ON submissions (status);

ALTER TABLE grades
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

CREATE UNIQUE INDEX IF NOT EXISTS grades_activity_student_unique ON grades (activity_id, student_id);

CREATE TABLE IF NOT EXISTS library_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    owner_id BIGINT UNSIGNED NULL,
    approved_by BIGINT UNSIGNED NULL,
    course_id BIGINT UNSIGNED NULL,
    class_id BIGINT UNSIGNED NULL,
    title VARCHAR(180) NOT NULL,
    description TEXT NULL,
    category VARCHAR(120) NULL,
    subject VARCHAR(120) NULL,
    item_type ENUM('pdf', 'livro', 'apostila', 'artigo', 'video', 'link', 'apresentacao', 'imagem', 'arquivo') NOT NULL DEFAULT 'arquivo',
    visibility ENUM('publica', 'logados', 'curso', 'privada_admin') NOT NULL DEFAULT 'publica',
    author VARCHAR(160) NULL,
    file_path VARCHAR(255) NULL,
    external_url VARCHAR(255) NULL,
    cover_path VARCHAR(255) NULL,
    status ENUM('rascunho', 'pendente', 'publicado', 'arquivado', 'recusado') NOT NULL DEFAULT 'pendente',
    moderation_notes VARCHAR(255) NULL,
    approved_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY library_status_index (status),
    KEY library_visibility_index (visibility),
    KEY library_category_index (category),
    KEY library_subject_index (subject),
    KEY library_type_index (item_type),
    CONSTRAINT fk_library_owner FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_library_approved_by FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_library_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE SET NULL,
    CONSTRAINT fk_library_class FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS library_favorites (
    user_id BIGINT UNSIGNED NOT NULL,
    library_item_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, library_item_id),
    CONSTRAINT fk_library_favorites_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_library_favorites_item FOREIGN KEY (library_item_id) REFERENCES library_items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS library_access_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    library_item_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NULL,
    accessed_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(255) NULL,
    KEY library_access_item_index (library_item_id),
    KEY library_access_user_index (user_id),
    CONSTRAINT fk_library_access_item FOREIGN KEY (library_item_id) REFERENCES library_items(id) ON DELETE CASCADE,
    CONSTRAINT fk_library_access_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
