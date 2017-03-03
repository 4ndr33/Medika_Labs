-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 03, 2017 at 10:52 AM
-- Server version: 5.6.11
-- PHP Version: 5.5.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `frostingdb`
--
CREATE DATABASE IF NOT EXISTS `frostingdb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `frostingdb`;

-- --------------------------------------------------------

--
-- Table structure for table `uf_authorize_group`
--

CREATE TABLE IF NOT EXISTS `uf_authorize_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL,
  `hook` varchar(200) NOT NULL COMMENT 'A code that references a specific action or URI that the group has access to.',
  `conditions` text NOT NULL COMMENT 'The conditions under which members of this group have access to this hook.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `uf_authorize_group`
--

INSERT INTO `uf_authorize_group` (`id`, `group_id`, `hook`, `conditions`) VALUES
(1, 1, 'uri_dashboard', 'always()'),
(2, 2, 'uri_dashboard', 'always()'),
(3, 2, 'uri_users', 'always()'),
(4, 1, 'uri_account_settings', 'always()'),
(5, 1, 'update_account_setting', 'equals(self.id, user.id)&&in(property,["email","locale","password"])'),
(6, 2, 'update_account_setting', '!in_group(user.id,2)&&in(property,["email","display_name","title","locale","flag_password_reset","flag_enabled"])'),
(7, 2, 'view_account_setting', 'in(property,["user_name","email","display_name","title","locale","flag_enabled","groups","primary_group_id"])'),
(8, 2, 'delete_account', '!in_group(user.id,2)'),
(9, 2, 'create_account', 'always()'),
(10, 1, 'uri_account-groups', 'always()'),
(11, 1, 'uri_group_titles', 'always()'),
(12, 2, 'uri_groups', 'always()'),
(13, 1, 'uri_log-ticket', 'always()'),
(14, 2, 'uri_log-ticket', 'always()'),
(15, 1, 'uri_pricing', 'always()'),
(16, 2, 'uri_tickets', 'always()'),
(17, 1, 'uri_ticket', 'always()');

-- --------------------------------------------------------

--
-- Table structure for table `uf_authorize_user`
--

CREATE TABLE IF NOT EXISTS `uf_authorize_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `hook` varchar(200) NOT NULL COMMENT 'A code that references a specific action or URI that the user has access to.',
  `conditions` text NOT NULL COMMENT 'The conditions under which the user has access to this action.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `uf_configuration`
--

CREATE TABLE IF NOT EXISTS `uf_configuration` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plugin` varchar(50) NOT NULL COMMENT 'The name of the plugin that manages this setting (set to ''userfrosting'' for core settings)',
  `name` varchar(150) NOT NULL COMMENT 'The name of the setting.',
  `value` longtext NOT NULL COMMENT 'The current value of the setting.',
  `description` text NOT NULL COMMENT 'A brief description of this setting.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='A configuration table, mapping global configuration options to their values.' AUTO_INCREMENT=20 ;

--
-- Dumping data for table `uf_configuration`
--

INSERT INTO `uf_configuration` (`id`, `plugin`, `name`, `value`, `description`) VALUES
(1, 'userfrosting', 'site_title', 'ProServ Plus', 'The title of the site.  By default, displayed in the title tag, as well as the upper left corner of every user page.'),
(2, 'userfrosting', 'admin_email', 'ian.gray@ptsg.com.au', 'The administrative email for the site.  Automated emails, such as verification emails and password reset links, will come from this address.'),
(3, 'userfrosting', 'email_login', '1', 'Specify whether users can login via email address or username instead of just username.'),
(4, 'userfrosting', 'can_register', '1', 'Specify whether public registration of new accounts is enabled.  Enable if you have a service that users can sign up for, disable if you only want accounts to be created by you or an admin.'),
(5, 'userfrosting', 'enable_captcha', '1', 'Specify whether new users must complete a captcha code when registering for an account.'),
(6, 'userfrosting', 'require_activation', '1', 'Specify whether email verification is required for newly registered accounts.  Accounts created by another user never need to be verified.'),
(7, 'userfrosting', 'resend_activation_threshold', '0', 'The time, in seconds, that a user must wait before requesting that the account verification email be resent.'),
(8, 'userfrosting', 'reset_password_timeout', '10800', 'The time, in seconds, before a user''s password reset token expires.'),
(9, 'userfrosting', 'create_password_expiration', '86400', 'The time, in seconds, before a new user''s password creation token expires.'),
(10, 'userfrosting', 'default_locale', 'en_US', 'The default language for newly registered users.'),
(11, 'userfrosting', 'guest_theme', 'default', 'The template theme to use for unauthenticated (guest) users.'),
(12, 'userfrosting', 'minify_css', '0', 'Specify whether to use concatenated, minified CSS (production) or raw CSS includes (dev).'),
(13, 'userfrosting', 'minify_js', '0', 'Specify whether to use concatenated, minified JS (production) or raw JS includes (dev).'),
(14, 'userfrosting', 'version', '0.3.1.20', 'The current version of UserFrosting.'),
(15, 'userfrosting', 'author', 'Ian Gray', 'The author of the site.  Will be used in the site''s author meta tag.'),
(16, 'userfrosting', 'show_terms_on_register', '1', 'Specify whether or not to show terms and conditions when registering.'),
(17, 'userfrosting', 'site_location', 'Australia', 'The nation or state in which legal jurisdiction for this site falls.'),
(18, 'userfrosting', 'install_status', 'complete', ''),
(19, 'userfrosting', 'root_account_config_token', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `uf_group`
--

CREATE TABLE IF NOT EXISTS `uf_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Specifies whether this permission is a default setting for new accounts.',
  `can_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Specifies whether this permission can be deleted from the control panel.',
  `theme` varchar(100) NOT NULL DEFAULT 'default' COMMENT 'The theme assigned to primary users in this group.',
  `landing_page` varchar(200) NOT NULL DEFAULT 'dashboard' COMMENT 'The page to take primary members to when they first log in.',
  `new_user_title` varchar(200) NOT NULL DEFAULT 'New User' COMMENT 'The default title to assign to new primary users.',
  `icon` varchar(100) NOT NULL DEFAULT 'fa fa-user' COMMENT 'The icon representing primary users in this group.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `uf_group`
--

INSERT INTO `uf_group` (`id`, `name`, `is_default`, `can_delete`, `theme`, `landing_page`, `new_user_title`, `icon`) VALUES
(1, 'User', 2, 0, 'default', 'dashboard/', 'New User', 'fa fa-user'),
(2, 'Administrator', 0, 0, 'nyx', 'dashboard', 'Brood Spawn', 'fa fa-flag'),
(3, 'Zerglings', 0, 1, 'nyx', 'dashboard', 'Tank Fodder', 'sc sc-zergling');

-- --------------------------------------------------------

--
-- Table structure for table `uf_group_user`
--

CREATE TABLE IF NOT EXISTS `uf_group_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Maps users to their group(s)' AUTO_INCREMENT=11 ;

--
-- Dumping data for table `uf_group_user`
--

INSERT INTO `uf_group_user` (`id`, `user_id`, `group_id`) VALUES
(5, 1, 2),
(6, 5, 1),
(8, 7, 1),
(9, 8, 1),
(10, 9, 1);

-- --------------------------------------------------------

--
-- Table structure for table `uf_staff_event`
--

CREATE TABLE IF NOT EXISTS `uf_staff_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `location` text NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `id_2` (`id`),
  UNIQUE KEY `id_3` (`id`),
  UNIQUE KEY `id_4` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `uf_staff_event_user`
--

CREATE TABLE IF NOT EXISTS `uf_staff_event_user` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `staff_event_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `uf_tickets`
--

CREATE TABLE IF NOT EXISTS `uf_tickets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sitecontact` varchar(200) NOT NULL,
  `siteaddress` text NOT NULL,
  `email` varchar(200) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `servicelevel` text NOT NULL,
  `servicetype` text NOT NULL,
  `notes` longtext NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` text NOT NULL,
  `admin_note` text NOT NULL,
  `user_photos_name_1` varchar(100) NOT NULL,
  `user_photos_name_2` varchar(100) NOT NULL,
  `user_photos_name_3` varchar(100) NOT NULL,
  `user_photos_name_4` varchar(100) NOT NULL,
  `user_photos_name_5` varchar(100) NOT NULL,
  `user_photos_name_6` varchar(100) NOT NULL,
  `user_photos_name_7` varchar(100) NOT NULL,
  `user_photos_name_8` varchar(100) NOT NULL,
  `user_photos_1` varchar(150) NOT NULL,
  `user_photos_2` varchar(150) NOT NULL,
  `user_photos_3` varchar(150) NOT NULL,
  `user_photos_4` varchar(150) NOT NULL,
  `user_photos_5` varchar(150) NOT NULL,
  `user_photos_6` varchar(150) NOT NULL,
  `user_photos_7` varchar(150) NOT NULL,
  `user_photos_8` varchar(150) NOT NULL,
  `admin_file_name_1` varchar(150) NOT NULL,
  `admin_file_name_2` varchar(150) NOT NULL,
  `admin_file_name_3` varchar(150) NOT NULL,
  `admin_file_name_4` varchar(150) NOT NULL,
  `admin_file_name_5` varchar(150) NOT NULL,
  `admin_file_name_6` varchar(150) NOT NULL,
  `admin_file_name_7` varchar(150) NOT NULL,
  `admin_file_name_8` varchar(150) NOT NULL,
  `admin_file_1` varchar(150) NOT NULL,
  `admin_file_2` varchar(150) NOT NULL,
  `admin_file_3` varchar(150) NOT NULL,
  `admin_file_4` varchar(150) NOT NULL,
  `admin_file_5` varchar(150) NOT NULL,
  `admin_file_6` varchar(150) NOT NULL,
  `admin_file_7` varchar(150) NOT NULL,
  `admin_file_8` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `uf_tickets`
--

INSERT INTO `uf_tickets` (`id`, `sitecontact`, `siteaddress`, `email`, `phone`, `servicelevel`, `servicetype`, `notes`, `user_id`, `status`, `admin_note`, `user_photos_name_1`, `user_photos_name_2`, `user_photos_name_3`, `user_photos_name_4`, `user_photos_name_5`, `user_photos_name_6`, `user_photos_name_7`, `user_photos_name_8`, `user_photos_1`, `user_photos_2`, `user_photos_3`, `user_photos_4`, `user_photos_5`, `user_photos_6`, `user_photos_7`, `user_photos_8`, `admin_file_name_1`, `admin_file_name_2`, `admin_file_name_3`, `admin_file_name_4`, `admin_file_name_5`, `admin_file_name_6`, `admin_file_name_7`, `admin_file_name_8`, `admin_file_1`, `admin_file_2`, `admin_file_3`, `admin_file_4`, `admin_file_5`, `admin_file_6`, `admin_file_7`, `admin_file_8`) VALUES
(3, 'asd', 'asdasdrrdt', 'qwe@c.osa', 'asdas', 'Priority', 'Not Sure', 'asdasf', 1, 'Awaiting response', 'dfgdfg', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'Chika.jpg', '', '', '', '', '', '', '', 'uploads/admfls-3-1-1.jpg', '', '', '', '', '', '', ''),
(4, 'as', 'qwe', 'd@d.com', 'asdfk', 'Priority', 'Not Sure', 'asdqw', 1, 'waiting for respond', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(5, 'asasdas', 'qweqweqw', 'd@d.comvc', 'asdfkdddddddd', 'Off-Peak', 'Telecommunications', 'asdqw asdasa asssssssssssssss\r\nqwe\r\ndfsd\r\nweqwasdas\r\nasdas', 1, 'waiting for respond', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(6, 'as', 'kqw', 'C@C.AS', 'ASKDAS', 'Priority', 'Not Sure', 'ASDAS\r\nQWE', 1, 'waiting for respond', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(7, 'afds', 'sdfs', 'd@d.com', 'sdfs', 'Priority', 'Not Sure', 'asdsf', 1, 'waiting for respond', '', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(8, 'as', 'd', 'we', 'wer', 'Priority', 'Not Sure', 'asd\r\nqwe\r\n', 1, 'waiting for respond', '', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(9, 'qwe', 'asd', 'd@f.com', 'asda', 'Priority', 'Not Sure', 'asd\r\nqwe\r\nasd', 1, 'waiting for respond', '', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(10, 'asd', 'qwq', 'd@d.com', 'asdka', 'Priority', 'Not Sure', 'asldams\r\nadmk', 1, 'waiting for respond', '', 'uploads/1-1.png', 'uploads/1-2.png', '-', '-', '-', '-', '-', '-', 'uploads/1-1.png', 'uploads/1-2.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(11, '', '', '', '', 'Priority', 'Not Sure', 'asdas', 1, 'waiting for respond', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(12, 'as', 'dsf', 'c@s.aom', 'asld', 'Priority', 'Not Sure', 'asdas', 1, 'waiting for respond', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(13, 'as', 'dsf', 'c@s.aom', 'asld', 'Priority', 'Not Sure', 'asdas', 1, 'waiting for respond', '', 'uploads/1-3.png', 'uploads/1-4.png', '-', '-', '-', '-', '-', '-', 'uploads/1-3.png', 'uploads/1-4.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(14, 'ss', 'ads,dfl', 'd@d.com', 'asdlk', 'Priority', 'Not Sure', 'asdqw\r\nqwe\r\nasad\r\n', 1, 'waiting for respond', '', 'user dashboard analytics.png.png', 'admin ticket update.png.png', '-', '-', '-', '-', '-', '-', 'uploads/1-5.png', 'uploads/1-6.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(15, 'd', 'as', 'das@d.cao', 'asda', 'Priority', 'Not Sure', 'qweqw\r\nasda\r\nsqw\r\n', 1, 'waiting for respond', '', 'user dashboard analytics.png', 'admin ticket update.png', '-', '-', '-', '-', '-', '-', 'uploads/1-7.png', 'uploads/1-8.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(16, 'sl', 'sdl', 'd@d.com', 'sdkf', 'Priority', 'Not Sure', 'asdas', 1, 'waiting for respond', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(17, 'as', 'sd', 'dc@c.asom', 'asdlas', 'Priority', 'Not Sure', 'Sa\r\nasdas\r\n', 1, 'waiting for respond', '', 'mega_win_20.png', 'mega_win_21.png', 'mega_win_22.png', 'mega_win_23.png', 'mega_win_24.png', 'mega_win_25.png', 'mega_win_26.png', 'mega_win_27.png', 'uploads/1-9.png', 'uploads/1-10.png', 'uploads/1-11.png', 'uploads/1-12.png', 'uploads/1-13.png', 'uploads/1-14.png', 'uploads/1-15.png', 'uploads/1-16.png', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(18, 'qw', '12', 's@2.com', 'sdkjas', 'Priority', 'Not Sure', 'asd\r\nqweqw\r\n', 1, 'Complete', 'asdaswqv qwdasda\r\nas\r\nd\r\nasdqw\r\n\r\nasd', 'tampilan program.jpg', '-', '-', '-', '-', '-', '-', '-', 'uploads/1-1.jpg', '-', '-', '-', '-', '-', '-', '-', 'index.php', '_45_BatteringRam_Attack.png', '_45_BatteringRam_Attack.png.meta', '_45_BatteringRam_Idle.png', '-', '-', '-', '-', 'uploads/admfls-18-1-1.php', 'uploads/admfls-18-1-2.png', 'uploads/admfls-18-1-3.meta', 'uploads/admfls-18-1-4.png', '-', '-', '-', '-'),
(20, 'fgdf', 'dfs', 'd@d.com', 'as', 'Priority', 'Not Sure', 'qwd\r\nas', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(21, 'sd', 'qw', 'dA@d.com', 'asd', 'Priority', 'Not Sure', 'sdf', 1, 'Awaiting response', '', '_45_Archer_Attack.png', '_45_Archer_Hitted.png', '_45_Archer_Idle.png', '_45_Archer_Run.png', '_45_Armis_Attack.png', '_45_Armis_Hitted.png', '_45_Armis_Idle.png', '_45_Armis_Run.png', 'uploads/1-17.png', 'uploads/1-18.png', 'uploads/1-19.png', 'uploads/1-20.png', 'uploads/1-21.png', 'uploads/1-22.png', 'uploads/1-23.png', 'uploads/1-24.png', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(22, 'd', 'ds', '2@d.coa', 'asdasd', 'Priority', 'Not Sure', 'asd', 1, 'Awaiting response', '', '1468595497667.jpg', '-', '-', '-', '-', '-', '-', '-', 'uploads/1-2.jpg', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(23, 'gh', 'sd', 'f@f.vom', 'sd', 'Priority', 'Not Sure', 'sdf', 1, 'Awaiting response', '', 'Chrysanthemum.jpg', 'Desert.jpg', 'Hydrangeas.jpg', 'Jellyfish.jpg', 'Koala.jpg', 'Lighthouse.jpg', 'Penguins.jpg', 'Tulips.jpg', 'uploads/1-3.jpg', 'uploads/1-4.jpg', 'uploads/1-5.jpg', 'uploads/1-6.jpg', 'uploads/1-7.jpg', 'uploads/1-8.jpg', 'uploads/1-9.jpg', 'uploads/1-10.jpg', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(24, 'd', 'a', 's@f.vk', 'sdf', 'Priority', 'Not Sure', 'werwe', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(25, 'asda', 'asd', 'dd@d.com', 'asdas', 'Off-Peak', 'Not Sure', 'asdsdfsd', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(26, 'k', 'as', 'd@d.com', 'asd', 'Priority', 'Not Sure', 's', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(27, 's', 'd', 's@d.com', 'asd', 'Priority', 'Not Sure', 'asd', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(28, 's', 's', 's@c.ask', 's', 'Priority', 'Not Sure', 'as', 5, 'Awaiting response', '', 'Jellyfish.jpg', '-', '-', '-', '-', '-', '-', '-', 'uploads/5-1.jpg', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(29, 'd', 'sd', 'd@d.com', 'sdfsd', 'Priority', 'Not Sure', 'sdfsd', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
(30, 'd', 'aasa', 'f@c.a', 'asd', 'Off-Peak', 'Not Sure', 'qweqw', 1, 'Awaiting response', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `uf_tickets_worklog`
--

CREATE TABLE IF NOT EXISTS `uf_tickets_worklog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint(20) NOT NULL,
  `time_stamp` varchar(50) NOT NULL,
  `log_content` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `uf_tickets_worklog`
--

INSERT INTO `uf_tickets_worklog` (`id`, `ticket_id`, `time_stamp`, `log_content`) VALUES
(1, 30, '03/01/17 03:18', 'created');

-- --------------------------------------------------------

--
-- Table structure for table `uf_user`
--

CREATE TABLE IF NOT EXISTS `uf_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `display_name` varchar(50) NOT NULL,
  `email` varchar(150) NOT NULL,
  `title` varchar(150) NOT NULL,
  `locale` varchar(10) NOT NULL DEFAULT 'en_US' COMMENT 'The language and locale to use for this user.',
  `primary_group_id` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'The id of this user''s primary group.',
  `secret_token` varchar(32) NOT NULL DEFAULT '' COMMENT 'The current one-time use token for various user activities confirmed via email.',
  `flag_verified` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Set to ''1'' if the user has verified their account via email, ''0'' otherwise.',
  `flag_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Set to ''1'' if the user''s account is currently enabled, ''0'' otherwise.  Disabled accounts cannot be logged in to, but they retain all of their data and settings.',
  `flag_password_reset` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Set to ''1'' if the user has an outstanding password reset request, ''0'' otherwise.',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `uf_user`
--

INSERT INTO `uf_user` (`id`, `user_name`, `display_name`, `email`, `title`, `locale`, `primary_group_id`, `secret_token`, `flag_verified`, `flag_enabled`, `flag_password_reset`, `created_at`, `updated_at`, `password`) VALUES
(1, 'iangray', 'Ian Gray', 'ian@clevertangent.com', 'New User', 'en_US', 2, '', 1, 1, 0, '2016-12-03 06:15:22', '2016-12-17 21:43:25', '$2y$10$.4/B93iuSzrDHrhj2gfGLO3FRPtRgo1zQyThZOQmfw/qDHZavB3GS'),
(5, 'regionalmanager', 'Regional Manager', 'ian.gray@ptsg.com.au', 'Manager', 'en_US', 1, '3a6d4323cd5dd0d7fdf9241d901ffe31', 1, 1, 0, '2016-12-04 15:46:12', '2016-12-10 19:02:08', '$2y$10$MObDDsWn8E.by0S9S0nTbeAGyaSeRSYKj.pUNxPdHuSV6nmivSkue'),
(7, 'Paul Lyon', 'Paul Lyon', 'paul.lyon@paltechservices.com.au', 'New User', 'en_US', 1, '8225b0c24cc6cd0178cf72126b02954e', 1, 1, 0, '2016-12-12 22:56:02', '2016-12-12 22:56:32', '$2y$10$Zqjh8Nwllz/x3SsZoWI4KOK4SK9r.Zs/hfkFrgRLTQtGbljqXY.Gm'),
(8, 'Dean Deighton', 'Dean D', 'dean@2dstrategics.com.au', 'New User', 'en_US', 1, '6a7cbd394eb07d69de80e4bf1b7e5c61', 1, 1, 0, '2016-12-13 00:28:55', '2016-12-13 00:29:41', '$2y$10$cSpNyRLkBFZ29alyDkR4t.dCkCHScNDUGyv7BHkuheGQiERA.Wi/q'),
(9, 'Ross', 'Abergowrie Elec', 'abergowrieelec@itnq.com.au', 'New User', 'en_US', 1, '0ba7ef8ed04185268e9a1e23f9b5f096', 1, 1, 0, '2016-12-13 15:39:19', '2016-12-13 15:42:06', '$2y$10$tm77Yqvy.fEEPom.pDcwPuOE75bEc.7kXAwc3TyTcZ3ZUjLePzsim');

-- --------------------------------------------------------

--
-- Table structure for table `uf_user_event`
--

CREATE TABLE IF NOT EXISTS `uf_user_event` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `event_type` varchar(255) NOT NULL COMMENT 'An identifier used to track the type of event.',
  `occurred_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=127 ;

--
-- Dumping data for table `uf_user_event`
--

INSERT INTO `uf_user_event` (`id`, `user_id`, `event_type`, `occurred_at`, `description`) VALUES
(1, 1, 'sign_up', '2016-12-03 11:15:22', 'User iangray successfully registered on 2016-12-03 06:15:22.'),
(2, 1, 'sign_in', '2016-12-03 11:15:29', 'User iangray signed in at 2016-12-03 06:15:29.'),
(3, 1, 'sign_in', '2016-12-03 11:22:52', 'User iangray signed in at 2016-12-03 06:22:52.'),
(4, 1, 'sign_in', '2016-12-03 11:58:34', 'User iangray signed in at 2016-12-03 06:58:34.'),
(5, 1, 'sign_in', '2016-12-03 12:00:12', 'User iangray signed in at 2016-12-03 07:00:12.'),
(12, 1, 'sign_in', '2016-12-03 12:09:01', 'User iangray signed in at 2016-12-03 07:09:01.'),
(17, 1, 'sign_in', '2016-12-03 22:25:29', 'User iangray signed in at 2016-12-03 17:25:29.'),
(18, 1, 'sign_in', '2016-12-04 10:46:23', 'User iangray signed in at 2016-12-04 05:46:23.'),
(20, 1, 'sign_in', '2016-12-04 20:38:21', 'User iangray signed in at 2016-12-04 15:38:21.'),
(24, 5, 'sign_up', '2016-12-04 20:46:12', 'User regionalmanager was created by iangray on 2016-12-04 15:46:12.'),
(25, 5, 'password_reset_request', '2016-12-04 20:46:12', 'User regionalmanager requested a password reset on 2016-12-04 15:46:12.'),
(26, 5, 'password_reset_request', '2016-12-04 20:47:26', 'User regionalmanager requested a password reset on 2016-12-04 15:47:24.'),
(27, 5, 'password_reset_request', '2016-12-04 20:48:24', 'User regionalmanager requested a password reset on 2016-12-04 15:48:21.'),
(28, 1, 'sign_in', '2016-12-04 20:48:48', 'User iangray signed in at 2016-12-04 15:48:48.'),
(29, 5, 'sign_in', '2016-12-04 20:49:18', 'User regionalmanager signed in at 2016-12-04 15:49:18.'),
(30, 5, 'sign_in', '2016-12-05 04:11:00', 'User regionalmanager signed in at 2016-12-04 23:11:00.'),
(31, 5, 'sign_in', '2016-12-05 23:08:13', 'User regionalmanager signed in at 2016-12-05 18:08:13.'),
(32, 5, 'sign_in', '2016-12-06 00:57:59', 'User regionalmanager signed in at 2016-12-05 19:57:59.'),
(33, 5, 'sign_in', '2016-12-07 00:56:38', 'User regionalmanager signed in at 2016-12-06 19:56:38.'),
(34, 1, 'sign_in', '2016-12-08 08:07:16', 'User iangray signed in at 2016-12-08 03:07:16.'),
(35, 5, 'sign_in', '2016-12-08 08:07:37', 'User regionalmanager signed in at 2016-12-08 03:07:37.'),
(36, 5, 'sign_in', '2016-12-08 08:44:01', 'User regionalmanager signed in at 2016-12-08 03:44:01.'),
(37, 1, 'sign_in', '2016-12-08 09:00:29', 'User iangray signed in at 2016-12-08 04:00:29.'),
(38, 5, 'sign_in', '2016-12-08 09:03:07', 'User regionalmanager signed in at 2016-12-08 04:03:07.'),
(39, 5, 'sign_in', '2016-12-08 11:31:59', 'User regionalmanager signed in at 2016-12-08 06:31:59.'),
(40, 1, 'sign_in', '2016-12-08 11:32:23', 'User iangray signed in at 2016-12-08 06:32:23.'),
(41, 5, 'sign_in', '2016-12-08 11:32:48', 'User regionalmanager signed in at 2016-12-08 06:32:48.'),
(42, 5, 'sign_in', '2016-12-08 11:39:03', 'User regionalmanager signed in at 2016-12-08 06:39:03.'),
(46, 1, 'sign_in', '2016-12-09 01:26:02', 'User iangray signed in at 2016-12-08 20:26:02.'),
(47, 5, 'sign_in', '2016-12-09 01:49:20', 'User regionalmanager signed in at 2016-12-08 20:49:20.'),
(48, 5, 'sign_in', '2016-12-09 01:50:35', 'User regionalmanager signed in at 2016-12-08 20:50:35.'),
(49, 1, 'sign_in', '2016-12-09 05:40:26', 'User iangray signed in at 2016-12-09 00:40:26.'),
(50, 5, 'sign_in', '2016-12-09 11:20:50', 'User regionalmanager signed in at 2016-12-09 06:20:50.'),
(51, 5, 'sign_in', '2016-12-09 12:05:38', 'User regionalmanager signed in at 2016-12-09 07:05:38.'),
(52, 5, 'sign_in', '2016-12-10 23:45:51', 'User regionalmanager signed in at 2016-12-10 18:45:51.'),
(53, 1, 'sign_in', '2016-12-10 23:55:48', 'User iangray signed in at 2016-12-10 18:55:48.'),
(54, 5, 'sign_in', '2016-12-11 05:36:59', 'User regionalmanager signed in at 2016-12-11 00:36:59.'),
(55, 1, 'sign_in', '2016-12-11 05:39:35', 'User iangray signed in at 2016-12-11 00:39:35.'),
(56, 5, 'sign_in', '2016-12-11 06:20:14', 'User regionalmanager signed in at 2016-12-11 01:20:14.'),
(57, 5, 'sign_in', '2016-12-11 09:22:37', 'User regionalmanager signed in at 2016-12-11 04:22:37.'),
(58, 5, 'sign_in', '2016-12-11 23:07:56', 'User regionalmanager signed in at 2016-12-11 18:07:56.'),
(59, 5, 'sign_in', '2016-12-12 00:40:27', 'User regionalmanager signed in at 2016-12-11 19:40:27.'),
(60, 1, 'sign_in', '2016-12-12 01:38:09', 'User iangray signed in at 2016-12-11 20:38:09.'),
(61, 5, 'sign_in', '2016-12-12 01:40:33', 'User regionalmanager signed in at 2016-12-11 20:40:33.'),
(62, 5, 'sign_in', '2016-12-12 02:01:07', 'User regionalmanager signed in at 2016-12-11 21:01:07.'),
(63, 5, 'sign_in', '2016-12-12 02:41:51', 'User regionalmanager signed in at 2016-12-11 21:41:51.'),
(64, 5, 'sign_in', '2016-12-12 04:28:52', 'User regionalmanager signed in at 2016-12-11 23:28:52.'),
(65, 5, 'sign_in', '2016-12-12 06:55:46', 'User regionalmanager signed in at 2016-12-12 01:55:46.'),
(66, 5, 'sign_in', '2016-12-12 08:07:17', 'User regionalmanager signed in at 2016-12-12 03:07:17.'),
(67, 5, 'sign_in', '2016-12-12 10:41:49', 'User regionalmanager signed in at 2016-12-12 05:41:49.'),
(68, 5, 'sign_in', '2016-12-12 20:49:14', 'User regionalmanager signed in at 2016-12-12 15:49:14.'),
(69, 7, 'sign_up', '2016-12-13 03:56:02', 'User Paul Lyon successfully registered on 2016-12-12 22:56:02.'),
(70, 7, 'verification_request', '2016-12-13 03:56:02', 'User Paul Lyon requested verification on 2016-12-12 22:56:02.'),
(71, 7, 'sign_in', '2016-12-13 03:56:39', 'User Paul Lyon signed in at 2016-12-12 22:56:39.'),
(72, 8, 'sign_up', '2016-12-13 05:28:55', 'User Dean Deighton successfully registered on 2016-12-13 00:28:55.'),
(73, 8, 'verification_request', '2016-12-13 05:28:55', 'User Dean Deighton requested verification on 2016-12-13 00:28:55.'),
(74, 8, 'sign_in', '2016-12-13 05:30:23', 'User Dean Deighton signed in at 2016-12-13 00:30:23.'),
(75, 9, 'sign_up', '2016-12-13 20:39:19', 'User Ross successfully registered on 2016-12-13 15:39:19.'),
(76, 9, 'verification_request', '2016-12-13 20:39:19', 'User Ross requested verification on 2016-12-13 15:39:19.'),
(77, 9, 'sign_in', '2016-12-13 20:44:24', 'User Ross signed in at 2016-12-13 15:44:24.'),
(78, 5, 'sign_in', '2016-12-14 08:51:37', 'User regionalmanager signed in at 2016-12-14 03:51:37.'),
(79, 5, 'sign_in', '2016-12-14 23:30:41', 'User regionalmanager signed in at 2016-12-14 18:30:41.'),
(80, 5, 'sign_in', '2016-12-15 01:01:33', 'User regionalmanager signed in at 2016-12-14 20:01:33.'),
(81, 5, 'sign_in', '2016-12-15 03:32:20', 'User regionalmanager signed in at 2016-12-14 22:32:20.'),
(82, 5, 'sign_in', '2016-12-15 05:41:54', 'User regionalmanager signed in at 2016-12-15 00:41:54.'),
(83, 5, 'sign_in', '2016-12-15 05:49:36', 'User regionalmanager signed in at 2016-12-15 00:49:36.'),
(84, 1, 'sign_in', '2016-12-15 05:51:23', 'User iangray signed in at 2016-12-15 00:51:23.'),
(85, 5, 'sign_in', '2016-12-15 05:58:12', 'User regionalmanager signed in at 2016-12-15 00:58:12.'),
(86, 5, 'sign_in', '2016-12-15 08:27:31', 'User regionalmanager signed in at 2016-12-15 03:27:31.'),
(87, 5, 'sign_in', '2016-12-18 00:17:29', 'User regionalmanager signed in at 2016-12-17 19:17:29.'),
(88, 5, 'sign_in', '2016-12-18 01:48:52', 'User regionalmanager signed in at 2016-12-17 20:48:52.'),
(89, 5, 'sign_in', '2016-12-18 02:15:49', 'User regionalmanager signed in at 2016-12-17 21:15:49.'),
(90, 5, 'sign_in', '2016-12-18 02:17:39', 'User regionalmanager signed in at 2016-12-17 21:17:39.'),
(91, 1, 'sign_in', '2016-12-18 02:43:08', 'User iangray signed in at 2016-12-17 21:43:08.'),
(92, 5, 'sign_in', '2016-12-18 03:52:03', 'User regionalmanager signed in at 2016-12-17 22:52:03.'),
(93, 1, 'sign_in', '2016-12-18 05:16:50', 'User iangray signed in at 2016-12-18 00:16:50.'),
(94, 5, 'sign_in', '2016-12-18 05:17:29', 'User regionalmanager signed in at 2016-12-18 00:17:29.'),
(95, 5, 'sign_in', '2016-12-18 07:46:53', 'User regionalmanager signed in at 2016-12-18 02:46:53.'),
(96, 1, 'sign_in', '2016-12-18 07:50:13', 'User iangray signed in at 2016-12-18 02:50:13.'),
(97, 1, 'sign_in', '2016-12-18 08:51:24', 'User iangray signed in at 2016-12-18 03:51:24.'),
(98, 1, 'sign_in', '2016-12-18 08:57:15', 'User iangray signed in at 2016-12-18 03:57:15.'),
(99, 1, 'sign_in', '2016-12-18 09:06:55', 'User iangray signed in at 2016-12-18 04:06:55.'),
(100, 1, 'sign_in', '2016-12-18 09:13:24', 'User iangray signed in at 2016-12-18 04:13:24.'),
(101, 1, 'sign_in', '2016-12-18 09:14:55', 'User iangray signed in at 2016-12-18 04:14:55.'),
(102, 1, 'sign_in', '2016-12-18 09:26:39', 'User iangray signed in at 2016-12-18 04:26:39.'),
(103, 1, 'sign_in', '2016-12-18 13:04:34', 'User iangray signed in at 2016-12-18 08:04:34.'),
(104, 5, 'sign_in', '2016-12-18 13:51:36', 'User regionalmanager signed in at 2016-12-18 08:51:36.'),
(105, 5, 'sign_in', '2016-12-18 13:57:04', 'User regionalmanager signed in at 2016-12-18 08:57:04.'),
(106, 1, 'sign_in', '2016-12-18 13:58:14', 'User iangray signed in at 2016-12-18 08:58:14.'),
(107, 1, 'sign_in', '2016-12-22 10:40:58', 'User iangray signed in at 2016-12-22 05:40:58.'),
(108, 1, 'sign_in', '2016-12-22 14:07:54', 'User iangray signed in at 2016-12-22 09:07:54.'),
(109, 1, 'sign_in', '2016-12-23 16:17:44', 'User iangray signed in at 2016-12-23 11:17:44.'),
(110, 1, 'sign_in', '2016-12-24 08:37:39', 'User iangray signed in at 2016-12-24 03:37:39.'),
(111, 1, 'sign_in', '2016-12-25 15:52:08', 'User iangray signed in at 2016-12-25 10:52:08.'),
(112, 1, 'sign_in', '2016-12-26 04:16:25', 'User iangray signed in at 2016-12-25 23:16:25.'),
(113, 1, 'sign_in', '2016-12-26 12:45:02', 'User iangray signed in at 2016-12-26 07:45:02.'),
(114, 1, 'sign_in', '2016-12-27 02:36:25', 'User iangray signed in at 2016-12-26 21:36:25.'),
(115, 1, 'sign_in', '2016-12-27 13:27:10', 'User iangray signed in at 2016-12-27 08:27:10.'),
(116, 5, 'sign_in', '2016-12-27 13:38:01', 'User regionalmanager signed in at 2016-12-27 08:38:01.'),
(117, 1, 'sign_in', '2016-12-27 13:38:53', 'User iangray signed in at 2016-12-27 08:38:53.'),
(118, 5, 'sign_in', '2016-12-27 13:51:43', 'User regionalmanager signed in at 2016-12-27 08:51:43.'),
(119, 5, 'sign_in', '2016-12-28 02:32:50', 'User regionalmanager signed in at 2016-12-27 21:32:50.'),
(120, 5, 'sign_in', '2016-12-28 03:43:17', 'User regionalmanager signed in at 2016-12-27 22:43:17.'),
(121, 1, 'sign_in', '2016-12-28 04:02:59', 'User iangray signed in at 2016-12-27 23:02:59.'),
(122, 1, 'sign_in', '2016-12-28 13:20:47', 'User iangray signed in at 2016-12-28 08:20:47.'),
(123, 5, 'sign_in', '2016-12-28 13:56:17', 'User regionalmanager signed in at 2016-12-28 08:56:17.'),
(124, 1, 'sign_in', '2016-12-28 14:00:46', 'User iangray signed in at 2016-12-28 09:00:46.'),
(125, 1, 'sign_in', '2017-01-02 14:11:54', 'User iangray signed in at 2017-01-02 09:11:54.'),
(126, 1, 'sign_in', '2017-01-03 08:07:40', 'User iangray signed in at 2017-01-03 03:07:40.');

-- --------------------------------------------------------

--
-- Table structure for table `uf_user_rememberme`
--

CREATE TABLE IF NOT EXISTS `uf_user_rememberme` (
  `user_id` int(11) NOT NULL,
  `token` varchar(40) NOT NULL,
  `persistent_token` varchar(40) NOT NULL,
  `expires` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
