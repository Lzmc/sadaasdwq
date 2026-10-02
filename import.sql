-- =========================================================
-- NPWD SQL - MySQL 8 / Aiven compatible
-- =========================================================

-- Optional:
-- Only enable this if you actually have a `users` table.
-- ALTER TABLE `users`
-- ADD COLUMN `phone_number` VARCHAR(20) DEFAULT NULL;


-- =========================================================
-- TWITTER PROFILES
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_twitter_profiles`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `profile_name` VARCHAR(90) NOT NULL,
    `identifier` VARCHAR(48) NOT NULL COLLATE utf8mb4_general_ci,
    `avatar_url` VARCHAR(255) DEFAULT 'https://i.fivemanage.com/images/3ClWwmpwkFhL.png',
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `profile_name_UNIQUE` (`profile_name`),
    KEY `identifier` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- PHONE CONTACTS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_phone_contacts`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) DEFAULT NULL COLLATE utf8mb4_general_ci,
    `avatar` VARCHAR(255) DEFAULT NULL,
    `number` VARCHAR(20) DEFAULT NULL,
    `display` VARCHAR(255) NOT NULL DEFAULT '',

    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- TWITTER TWEETS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_twitter_tweets`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `message` VARCHAR(1000) NOT NULL COLLATE utf8mb4_general_ci,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `likes` INT NOT NULL DEFAULT 0,
    `identifier` VARCHAR(48) NOT NULL COLLATE utf8mb4_general_ci,
    `visible` TINYINT NOT NULL DEFAULT 1,
    `images` VARCHAR(1000) DEFAULT '',
    `retweet` INT DEFAULT NULL,
    `profile_id` INT NOT NULL,

    PRIMARY KEY (`id`),
    KEY `twitter_tweets_profile_idx` (`profile_id`),

    CONSTRAINT `twitter_tweets_profile_fk`
        FOREIGN KEY (`profile_id`)
        REFERENCES `npwd_twitter_profiles` (`id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- TWITTER LIKES
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_twitter_likes`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `profile_id` INT NOT NULL,
    `tweet_id` INT NOT NULL,

    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_combination` (`profile_id`, `tweet_id`),
    KEY `profile_idx` (`profile_id`),
    KEY `tweet_idx` (`tweet_id`),

    CONSTRAINT `twitter_likes_profile_fk`
        FOREIGN KEY (`profile_id`)
        REFERENCES `npwd_twitter_profiles` (`id`),

    CONSTRAINT `twitter_likes_tweet_fk`
        FOREIGN KEY (`tweet_id`)
        REFERENCES `npwd_twitter_tweets` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- MATCH PROFILES
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_match_profiles`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) NOT NULL COLLATE utf8mb4_general_ci,
    `name` VARCHAR(90) NOT NULL,
    `image` VARCHAR(255) NOT NULL,
    `bio` VARCHAR(512) DEFAULT NULL,
    `location` VARCHAR(45) DEFAULT NULL,
    `job` VARCHAR(45) DEFAULT NULL,
    `tags` VARCHAR(255) NOT NULL DEFAULT '',
    `voiceMessage` VARCHAR(512) DEFAULT NULL,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier_UNIQUE` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- MATCH VIEWS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_match_views`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) NOT NULL COLLATE utf8mb4_general_ci,
    `profile` INT NOT NULL,
    `liked` TINYINT DEFAULT 0,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    KEY `match_profile_idx` (`profile`),
    KEY `match_views_identifier_idx` (`identifier`),

    CONSTRAINT `match_views_profile_fk`
        FOREIGN KEY (`profile`)
        REFERENCES `npwd_match_profiles` (`id`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- NOTES
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_notes`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) NOT NULL COLLATE utf8mb4_general_ci,
    `title` VARCHAR(255) NOT NULL,
    `content` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`id`),
    KEY `notes_identifier_idx` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- MARKETPLACE
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_marketplace_listings`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) DEFAULT NULL COLLATE utf8mb4_general_ci,
    `username` VARCHAR(255) DEFAULT NULL,
    `name` VARCHAR(50) DEFAULT NULL,
    `number` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) DEFAULT NULL,
    `url` VARCHAR(255) DEFAULT NULL,
    `description` VARCHAR(255) NOT NULL,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `reported` TINYINT NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    KEY `marketplace_identifier_idx` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- TWITTER REPORTS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_twitter_reports`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `profile_id` INT NOT NULL,
    `tweet_id` INT NOT NULL,

    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_combination` (`profile_id`, `tweet_id`),
    KEY `profile_idx` (`profile_id`),
    KEY `tweet_idx` (`tweet_id`),

    CONSTRAINT `twitter_reports_profile_fk`
        FOREIGN KEY (`profile_id`)
        REFERENCES `npwd_twitter_profiles` (`id`),

    CONSTRAINT `twitter_reports_tweet_fk`
        FOREIGN KEY (`tweet_id`)
        REFERENCES `npwd_twitter_tweets` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- MESSAGES
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_messages`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `message` VARCHAR(512) NOT NULL COLLATE utf8mb4_general_ci,
    `user_identifier` VARCHAR(48) NOT NULL COLLATE utf8mb4_general_ci,
    `conversation_id` VARCHAR(512) NOT NULL,
    `isRead` TINYINT NOT NULL DEFAULT 0,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `visible` TINYINT NOT NULL DEFAULT 1,
    `author` VARCHAR(255) NOT NULL,
    `is_embed` TINYINT NOT NULL DEFAULT 0,
    `embed` VARCHAR(512) NOT NULL DEFAULT '',

    PRIMARY KEY (`id`),
    KEY `messages_user_identifier_idx` (`user_identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- MESSAGE CONVERSATIONS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_messages_conversations`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `conversation_list` VARCHAR(225) NOT NULL COLLATE utf8mb4_general_ci,
    `label` VARCHAR(60) DEFAULT '',
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_message_id` INT DEFAULT NULL,
    `is_group_chat` TINYINT NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- MESSAGE PARTICIPANTS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_messages_participants`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `conversation_id` INT NOT NULL,
    `participant` VARCHAR(225) NOT NULL COLLATE utf8mb4_general_ci,
    `unread_count` INT DEFAULT 0,

    PRIMARY KEY (`id`),
    KEY `participants_conversation_idx` (`conversation_id`),

    CONSTRAINT `participants_conversation_fk`
        FOREIGN KEY (`conversation_id`)
        REFERENCES `npwd_messages_conversations` (`id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- CALLS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_calls`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) DEFAULT NULL COLLATE utf8mb4_general_ci,
    `transmitter` VARCHAR(255) NOT NULL,
    `receiver` VARCHAR(255) NOT NULL,
    `is_accepted` TINYINT DEFAULT 0,
    `isAnonymous` TINYINT NOT NULL DEFAULT 0,
    `start` VARCHAR(255) DEFAULT NULL,
    `end` VARCHAR(255) DEFAULT NULL,

    PRIMARY KEY (`id`),
    KEY `calls_identifier_idx` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- PHONE GALLERY
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_phone_gallery`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(48) DEFAULT NULL COLLATE utf8mb4_general_ci,
    `image` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`id`),
    KEY `gallery_identifier_idx` (`identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;


-- =========================================================
-- DARKCHAT CHANNELS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_darkchat_channels`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `channel_identifier` VARCHAR(191) NOT NULL COLLATE utf8mb4_general_ci,
    `label` VARCHAR(255) DEFAULT '',

    PRIMARY KEY (`id`),
    UNIQUE KEY `darkchat_channels_identifier_uindex`
        (`channel_identifier`)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
AUTO_INCREMENT=20;


-- =========================================================
-- DARKCHAT MEMBERS
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_darkchat_channel_members`
(
    `channel_id` INT NOT NULL,
    `user_identifier` VARCHAR(255) NOT NULL COLLATE utf8mb4_general_ci,
    `is_owner` TINYINT NOT NULL DEFAULT 0,

    PRIMARY KEY (`channel_id`, `user_identifier`),
    KEY `darkchat_channel_members_channel_idx` (`channel_id`),

    CONSTRAINT `npwd_darkchat_channel_members_channel_fk`
        FOREIGN KEY (`channel_id`)
        REFERENCES `npwd_darkchat_channels` (`id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_general_ci;

-- =========================================================
-- DARKCHAT MESSAGES
-- =========================================================

CREATE TABLE IF NOT EXISTS `npwd_darkchat_messages`
(
    `id` INT NOT NULL AUTO_INCREMENT,
    `channel_id` INT NOT NULL,
    `message` VARCHAR(255) NOT NULL COLLATE utf8mb4_general_ci,
    `user_identifier` VARCHAR(255) NOT NULL COLLATE utf8mb4_general_ci,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_image` TINYINT NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    KEY `darkchat_messages_channel_idx` (`channel_id`),

    CONSTRAINT `darkchat_messages_channel_fk`
        FOREIGN KEY (`channel_id`)
        REFERENCES `npwd_darkchat_channels` (`id`)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
AUTO_INCREMENT=31;
