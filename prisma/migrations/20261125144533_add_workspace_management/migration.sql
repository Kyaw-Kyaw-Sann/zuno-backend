-- CreateTable
CREATE TABLE `workspaces` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(120) NOT NULL,
    `slug` VARCHAR(120) NOT NULL,
    `description` TEXT NULL,
    `created_by` BIGINT UNSIGNED NOT NULL,
    `plan_id` BIGINT UNSIGNED NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `workspaces_slug_key`(`slug`),
    INDEX `workspaces_created_by_idx`(`created_by`),
    INDEX `workspaces_plan_id_idx`(`plan_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `workspace_members` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `workspace_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `role` ENUM('OWNER', 'ADMIN', 'MEMBER') NOT NULL,
    `joined_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),

    INDEX `workspace_members_user_id_workspace_id_idx`(`user_id`, `workspace_id`),
    UNIQUE INDEX `workspace_members_workspace_id_user_id_key`(`workspace_id`, `user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `workspace_invitations` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `workspace_id` BIGINT UNSIGNED NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `role` ENUM('ADMIN', 'MEMBER') NOT NULL,
    `token_hash` VARCHAR(255) NOT NULL,
    `status` ENUM('PENDING', 'ACCEPTED', 'REJECTED', 'REVOKED', 'EXPIRED') NOT NULL DEFAULT 'PENDING',
    `invited_by` BIGINT UNSIGNED NOT NULL,
    `expires_at` DATETIME(3) NOT NULL,
    `responded_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),

    UNIQUE INDEX `workspace_invitations_token_hash_key`(`token_hash`),
    INDEX `workspace_invitations_workspace_id_status_idx`(`workspace_id`, `status`),
    INDEX `workspace_invitations_email_status_idx`(`email`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `workspaces` ADD CONSTRAINT `workspaces_created_by_fkey` FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `workspaces` ADD CONSTRAINT `workspaces_plan_id_fkey` FOREIGN KEY (`plan_id`) REFERENCES `plans`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `workspace_members` ADD CONSTRAINT `workspace_members_workspace_id_fkey` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `workspace_members` ADD CONSTRAINT `workspace_members_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `workspace_invitations` ADD CONSTRAINT `workspace_invitations_workspace_id_fkey` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `workspace_invitations` ADD CONSTRAINT `workspace_invitations_invited_by_fkey` FOREIGN KEY (`invited_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
