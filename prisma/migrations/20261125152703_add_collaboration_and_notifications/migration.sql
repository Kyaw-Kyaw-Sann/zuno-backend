-- CreateTable
CREATE TABLE `task_comments` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `task_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `parent_comment_id` BIGINT UNSIGNED NULL,
    `content` TEXT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `task_comments_task_id_created_at_idx`(`task_id`, `created_at`),
    UNIQUE INDEX `task_comments_task_id_id_key`(`task_id`, `id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `task_activities` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `task_id` BIGINT UNSIGNED NOT NULL,
    `actor_id` BIGINT UNSIGNED NOT NULL,
    `action` VARCHAR(50) NOT NULL,
    `old_value` JSON NULL,
    `new_value` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),

    INDEX `task_activities_task_id_created_at_idx`(`task_id`, `created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `comment_mentions` (
    `comment_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,

    INDEX `comment_mentions_user_id_idx`(`user_id`),
    PRIMARY KEY (`comment_id`, `user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notifications` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `workspace_id` BIGINT UNSIGNED NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `message` TEXT NOT NULL,
    `data` JSON NULL,
    `read_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),

    INDEX `notifications_user_id_read_at_created_at_idx`(`user_id`, `read_at`, `created_at`),
    INDEX `notifications_workspace_id_created_at_idx`(`workspace_id`, `created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `task_comments` ADD CONSTRAINT `task_comments_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_comments` ADD CONSTRAINT `task_comments_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_comments` ADD CONSTRAINT `task_comments_task_id_parent_comment_id_fkey` FOREIGN KEY (`task_id`, `parent_comment_id`) REFERENCES `task_comments`(`task_id`, `id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `task_activities` ADD CONSTRAINT `task_activities_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_activities` ADD CONSTRAINT `task_activities_actor_id_fkey` FOREIGN KEY (`actor_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `comment_mentions` ADD CONSTRAINT `comment_mentions_comment_id_fkey` FOREIGN KEY (`comment_id`) REFERENCES `task_comments`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `comment_mentions` ADD CONSTRAINT `comment_mentions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notifications` ADD CONSTRAINT `notifications_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notifications` ADD CONSTRAINT `notifications_workspace_id_fkey` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
