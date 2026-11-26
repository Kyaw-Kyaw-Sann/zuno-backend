-- CreateTable
CREATE TABLE `auth_accounts` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `provider` ENUM('LOCAL', 'GOOGLE') NOT NULL,
   `provider_account_id` VARCHAR(255) COLLATE utf8mb4_0900_bin NOT NULL,
    `password_hash` VARCHAR(255) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT (utc_timestamp(3)),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `auth_accounts_provider_provider_account_id_key`(`provider`, `provider_account_id`),
    UNIQUE INDEX `auth_accounts_user_id_provider_key`(`user_id`, `provider`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `auth_accounts` ADD CONSTRAINT `auth_accounts_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
