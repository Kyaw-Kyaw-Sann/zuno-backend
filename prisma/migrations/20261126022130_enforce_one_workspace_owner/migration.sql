ALTER TABLE `workspace_members`
  DROP FOREIGN KEY `workspace_members_workspace_id_fkey`;

ALTER TABLE `workspace_members`
  ADD CONSTRAINT `workspace_members_workspace_id_fkey`
  FOREIGN KEY (`workspace_id`) REFERENCES `workspaces`(`id`)
  ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `workspace_members`
  ADD COLUMN `owner_workspace_id` BIGINT UNSIGNED
    GENERATED ALWAYS AS (
      CASE WHEN `role` = 'OWNER' THEN `workspace_id` ELSE NULL END
    ) STORED,
  ADD UNIQUE INDEX `workspace_members_one_owner_key` (`owner_workspace_id`);
