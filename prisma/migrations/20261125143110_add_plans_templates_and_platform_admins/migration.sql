-- CreateTable
CREATE TABLE `plans` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `code` ENUM('FREE', 'PRO') NOT NULL,
    `max_projects` INTEGER NOT NULL,
    `max_members` INTEGER NOT NULL,
    `max_tasks` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `plans_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `project_templates` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `code` ENUM('BLANK', 'SOFTWARE_DEVELOPMENT', 'BUG_TRACKING') NOT NULL,
    `description` TEXT NULL,
    `configuration` JSON NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `project_templates_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `platform_admins` (
    `user_id` BIGINT UNSIGNED NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),

    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `platform_admins` ADD CONSTRAINT `platform_admins_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
