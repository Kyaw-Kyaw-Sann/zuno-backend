-- CreateTable
CREATE TABLE `projects` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `workspace_id` BIGINT UNSIGNED NOT NULL,
    `template_id` BIGINT UNSIGNED NULL,
    `name` VARCHAR(150) NOT NULL,
    `project_key` VARCHAR(12) NOT NULL,
    `description` TEXT NULL,
    `status` ENUM('PLANNED', 'ACTIVE', 'COMPLETED') NOT NULL DEFAULT 'PLANNED',
    `deadline` DATE NULL,
    `created_by` BIGINT UNSIGNED NOT NULL,
    `next_task_number` BIGINT UNSIGNED NOT NULL DEFAULT 1,
    `archived_at` DATETIME(3) NULL,
    `deleted_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `projects_workspace_id_deleted_at_status_idx`(`workspace_id`, `deleted_at`, `status`),
    INDEX `projects_created_by_idx`(`created_by`),
    UNIQUE INDEX `projects_workspace_id_project_key_key`(`workspace_id`, `project_key`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `project_members` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `joined_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),

    INDEX `project_members_user_id_project_id_idx`(`user_id`, `project_id`),
    UNIQUE INDEX `project_members_project_id_user_id_key`(`project_id`, `user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `project_statuses` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `category` ENUM('TODO', 'IN_PROGRESS', 'DONE') NOT NULL,
    `position` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `project_statuses_project_id_position_idx`(`project_id`, `position`),
    UNIQUE INDEX `project_statuses_project_id_name_key`(`project_id`, `name`),
    UNIQUE INDEX `project_statuses_project_id_id_key`(`project_id`, `id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `projects` ADD CONSTRAINT `projects_workspace_id_fkey` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `projects` ADD CONSTRAINT `projects_template_id_fkey` FOREIGN KEY (`template_id`) REFERENCES `project_templates`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `projects` ADD CONSTRAINT `projects_created_by_fkey` FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `project_members` ADD CONSTRAINT `project_members_project_id_fkey` FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `project_members` ADD CONSTRAINT `project_members_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `project_statuses` ADD CONSTRAINT `project_statuses_project_id_fkey` FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
