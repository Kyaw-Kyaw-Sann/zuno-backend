-- CreateTable
CREATE TABLE `tasks` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `task_number` BIGINT UNSIGNED NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `status_id` BIGINT UNSIGNED NOT NULL,
    `priority` ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL DEFAULT 'MEDIUM',
    `assignee_id` BIGINT UNSIGNED NULL,
    `parent_task_id` BIGINT UNSIGNED NULL,
    `due_date` DATE NULL,
    `position` DECIMAL(20, 6) NOT NULL,
    `created_by` BIGINT UNSIGNED NOT NULL,
    `deleted_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `tasks_project_id_status_id_position_idx`(`project_id`, `status_id`, `position`),
    INDEX `tasks_assignee_id_deleted_at_due_date_idx`(`assignee_id`, `deleted_at`, `due_date`),
    INDEX `tasks_project_id_deleted_at_idx`(`project_id`, `deleted_at`),
    UNIQUE INDEX `tasks_project_id_task_number_key`(`project_id`, `task_number`),
    UNIQUE INDEX `tasks_project_id_id_key`(`project_id`, `id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `labels` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `color` CHAR(7) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `labels_project_id_name_key`(`project_id`, `name`),
    UNIQUE INDEX `labels_project_id_id_key`(`project_id`, `id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `task_labels` (
    `project_id` BIGINT UNSIGNED NOT NULL,
    `task_id` BIGINT UNSIGNED NOT NULL,
    `label_id` BIGINT UNSIGNED NOT NULL,

    INDEX `task_labels_project_id_label_id_idx`(`project_id`, `label_id`),
    PRIMARY KEY (`task_id`, `label_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_project_id_fkey` FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_project_id_status_id_fkey` FOREIGN KEY (`project_id`, `status_id`) REFERENCES `project_statuses`(`project_id`, `id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_assignee_id_fkey` FOREIGN KEY (`assignee_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_created_by_fkey` FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_project_id_parent_task_id_fkey` FOREIGN KEY (`project_id`, `parent_task_id`) REFERENCES `tasks`(`project_id`, `id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `labels` ADD CONSTRAINT `labels_project_id_fkey` FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_labels` ADD CONSTRAINT `task_labels_project_id_task_id_fkey` FOREIGN KEY (`project_id`, `task_id`) REFERENCES `tasks`(`project_id`, `id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_labels` ADD CONSTRAINT `task_labels_project_id_label_id_fkey` FOREIGN KEY (`project_id`, `label_id`) REFERENCES `labels`(`project_id`, `id`) ON DELETE RESTRICT ON UPDATE CASCADE;
