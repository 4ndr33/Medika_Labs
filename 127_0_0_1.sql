-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2017 at 10:42 AM
-- Server version: 5.6.11
-- PHP Version: 5.5.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dbmedikalabs`
--
CREATE DATABASE IF NOT EXISTS `dbmedikalabs` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `dbmedikalabs`;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=29 ;

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
(17, 1, 'uri_ticket', 'always()'),
(18, 4, 'uri_proserv_admin', 'always()'),
(20, 5, 'uri_provider', 'always()'),
(22, 1, 'uri_offers', 'always()'),
(23, 6, 'uri_provider_admin', 'always()'),
(25, 7, 'uri_provider_user', 'always()'),
(27, 8, 'uri_clientorg', 'always()'),
(28, 9, 'uri_clientadmin', 'always()');

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
-- Table structure for table `uf_barang`
--

CREATE TABLE IF NOT EXISTS `uf_barang` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_barang` varchar(50) NOT NULL,
  `nama_barang` varchar(150) NOT NULL,
  `merek` varchar(50) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_beli` bigint(20) NOT NULL,
  `harga_jual` bigint(20) NOT NULL,
  `stok` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`kode_barang`),
  KEY `user_id` (`nama_barang`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

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
(1, 'userfrosting', 'site_title', 'Medika Labs', 'The title of the site.  By default, displayed in the title tag, as well as the upper left corner of every user page.'),
(2, 'userfrosting', 'admin_email', 'dede1488@gmail.com', 'The administrative email for the site.  Automated emails, such as verification emails and password reset links, will come from this address.'),
(3, 'userfrosting', 'email_login', '1', 'Specify whether users can login via email address or username instead of just username.'),
(4, 'userfrosting', 'can_register', '1', 'Specify whether public registration of new accounts is enabled.  Enable if you have a service that users can sign up for, disable if you only want accounts to be created by you or an admin.'),
(5, 'userfrosting', 'enable_captcha', '0', 'Specify whether new users must complete a captcha code when registering for an account.'),
(6, 'userfrosting', 'require_activation', '1', 'Specify whether email verification is required for newly registered accounts.  Accounts created by another user never need to be verified.'),
(7, 'userfrosting', 'resend_activation_threshold', '0', 'The time, in seconds, that a user must wait before requesting that the account verification email be resent.'),
(8, 'userfrosting', 'reset_password_timeout', '10800', 'The time, in seconds, before a user''s password reset token expires.'),
(9, 'userfrosting', 'create_password_expiration', '86400', 'The time, in seconds, before a new user''s password creation token expires.'),
(10, 'userfrosting', 'default_locale', 'en_US', 'The default language for newly registered users.'),
(11, 'userfrosting', 'guest_theme', 'default', 'The template theme to use for unauthenticated (guest) users.'),
(12, 'userfrosting', 'minify_css', '0', 'Specify whether to use concatenated, minified CSS (production) or raw CSS includes (dev).'),
(13, 'userfrosting', 'minify_js', '0', 'Specify whether to use concatenated, minified JS (production) or raw JS includes (dev).'),
(14, 'userfrosting', 'version', '0.3.1.20', 'The current version of UserFrosting.'),
(15, 'userfrosting', 'author', 'Stefanus Andree', 'The author of the site.  Will be used in the site''s author meta tag.'),
(16, 'userfrosting', 'show_terms_on_register', '1', 'Specify whether or not to show terms and conditions when registering.'),
(17, 'userfrosting', 'site_location', 'Indonesia', 'The nation or state in which legal jurisdiction for this site falls.'),
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `uf_group`
--

INSERT INTO `uf_group` (`id`, `name`, `is_default`, `can_delete`, `theme`, `landing_page`, `new_user_title`, `icon`) VALUES
(1, 'User', 2, 0, 'default', 'dashboard/', 'New User', 'fa fa-user'),
(2, 'Administrator', 0, 0, 'nyx', 'dashboard', 'Brood Spawn', 'fa fa-flag'),
(3, 'Zerglings', 0, 1, 'nyx', 'dashboard', 'Tank Fodder', 'sc sc-zergling'),
(4, 'ProServAdmin', 0, 1, 'default', 'dashboard', 'ProServAdmin', 'fa fa-user'),
(5, 'Provider Organisation', 0, 1, 'default', 'dashboard', 'Provider Organisation', 'fa fa-user'),
(6, 'Provider Admin', 0, 1, 'default', 'dashboard', 'Provider Admin', 'fa fa-user'),
(7, 'Provider User', 0, 1, 'default', 'dashboard', 'Provider User', 'fa fa-user'),
(8, 'User Organisation', 0, 1, 'default', 'dashboard', 'User Organisation', 'fa fa-user'),
(9, 'User Admin', 0, 1, 'default', 'dashboard', 'User Admin', 'fa fa-user');

-- --------------------------------------------------------

--
-- Table structure for table `uf_group_user`
--

CREATE TABLE IF NOT EXISTS `uf_group_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Maps users to their group(s)' AUTO_INCREMENT=36 ;

--
-- Dumping data for table `uf_group_user`
--

INSERT INTO `uf_group_user` (`id`, `user_id`, `group_id`) VALUES
(5, 1, 2),
(6, 5, 1),
(8, 7, 1),
(9, 8, 1),
(10, 9, 1),
(13, 10, 1),
(14, 10, 4),
(15, 11, 1),
(16, 12, 1),
(17, 13, 1),
(18, 12, 5),
(19, 11, 5),
(20, 13, 8),
(21, 14, 8),
(22, 14, 1),
(23, 15, 1),
(24, 16, 1),
(25, 17, 1),
(26, 18, 1),
(27, 19, 1),
(28, 20, 1),
(29, 21, 1),
(30, 22, 1),
(31, 23, 1),
(32, 24, 1),
(33, 15, 6),
(34, 16, 7),
(35, 17, 9);

-- --------------------------------------------------------

--
-- Table structure for table `uf_offers`
--

CREATE TABLE IF NOT EXISTS `uf_offers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_id` int(11) NOT NULL,
  `dest_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `from_name` varchar(150) NOT NULL,
  `dest_name` varchar(150) NOT NULL,
  `position_name` varchar(150) NOT NULL,
  `provider_admin_id` int(11) NOT NULL,
  `provider_admin_name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `uf_offers`
--

INSERT INTO `uf_offers` (`id`, `from_id`, `dest_id`, `position_id`, `from_name`, `dest_name`, `position_name`, `provider_admin_id`, `provider_admin_name`) VALUES
(1, 11, 19, 6, 'provider1', 'user5', 'Provider Admin', 0, ''),
(2, 13, 19, 9, 'clientorg1', 'user5', 'User Admin', 0, ''),
(3, 11, 19, 7, 'provider1', 'user5', 'Provider User', 15, 'user1');

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
  `date_created` int(11) NOT NULL,
  `allocated_to` int(11) NOT NULL,
  `assigned_to` int(11) NOT NULL,
  `allocated_to_provider_admin` int(11) NOT NULL,
  `user_organisation_id` int(11) NOT NULL,
  `user_admin_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;

--
-- Dumping data for table `uf_tickets`
--

INSERT INTO `uf_tickets` (`id`, `sitecontact`, `siteaddress`, `email`, `phone`, `servicelevel`, `servicetype`, `notes`, `user_id`, `status`, `admin_note`, `user_photos_name_1`, `user_photos_name_2`, `user_photos_name_3`, `user_photos_name_4`, `user_photos_name_5`, `user_photos_name_6`, `user_photos_name_7`, `user_photos_name_8`, `user_photos_1`, `user_photos_2`, `user_photos_3`, `user_photos_4`, `user_photos_5`, `user_photos_6`, `user_photos_7`, `user_photos_8`, `admin_file_name_1`, `admin_file_name_2`, `admin_file_name_3`, `admin_file_name_4`, `admin_file_name_5`, `admin_file_name_6`, `admin_file_name_7`, `admin_file_name_8`, `admin_file_1`, `admin_file_2`, `admin_file_3`, `admin_file_4`, `admin_file_5`, `admin_file_6`, `admin_file_7`, `admin_file_8`, `date_created`, `allocated_to`, `assigned_to`, `allocated_to_provider_admin`, `user_organisation_id`, `user_admin_id`) VALUES
(4, 'as', 'qwe', 'd@d.com', 'asdfk', 'Priority', 'Not Sure', 'asdqw', 1, 'Assigned', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 11, 16, 15, 0, 0),
(5, 'asasdas', 'qweqweqw', 'd@d.comvc', 'asdfkdddddddd', 'Off-Peak', 'Telecommunications', 'asdqw asdasa asssssssssssssss\r\nqwe\r\ndfsd\r\nweqwasdas\r\nasdas', 1, 'Logged', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(6, 'as', 'kqw', 'C@C.AS', 'ASKDAS', 'Priority', 'Not Sure', 'ASDAS\r\nQWE', 1, 'Logged', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(7, 'afds', 'sdfs', 'd@d.com', 'sdfs', 'Priority', 'Not Sure', 'asdsf', 1, 'Logged', '', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(8, 'as', 'd', 'we', 'wer', 'Priority', 'Not Sure', 'asd\r\nqwe\r\n', 1, 'Logged', '', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(9, 'qwe', 'asd', 'd@f.com', 'asda', 'Priority', 'Not Sure', 'asd\r\nqwe\r\nasd', 1, 'Logged', '', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', 'uploads/user dashboard analytics.png', 'uploads/admin ticket update.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(10, 'asd', 'qwq', 'd@d.com', 'asdka', 'Off-Peak', 'Plumbing', 'asldams\r\nadmk', 1, 'Logged', '', 'uploads/1-1.png', 'uploads/1-2.png', '-', '-', '-', '-', '-', '-', 'uploads/1-1.png', 'uploads/1-2.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(11, '', '', '', '', 'Priority', 'Not Sure', 'asdas', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(12, 'as', 'dsf', 'c@s.aom', 'asld', 'Priority', 'Not Sure', 'asdas', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(13, 'as', 'dsf', 'c@s.aom', 'asld', 'Priority', 'Not Sure', 'asdas', 1, 'Logged', '', 'uploads/1-3.png', 'uploads/1-4.png', '-', '-', '-', '-', '-', '-', 'uploads/1-3.png', 'uploads/1-4.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(14, 'ss', 'ads,dfl', 'd@d.com', 'asdlk', 'Priority', 'Not Sure', 'asdqw\r\nqwe\r\nasad\r\n', 1, 'Logged', '', 'user dashboard analytics.png.png', 'admin ticket update.png.png', '-', '-', '-', '-', '-', '-', 'uploads/1-5.png', 'uploads/1-6.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(15, 'd', 'as', 'das@d.cao', 'asda', 'Priority', 'Not Sure', 'qweqw\r\nasda\r\nsqw\r\n', 1, 'Logged', '', 'user dashboard analytics.png', 'admin ticket update.png', '-', '-', '-', '-', '-', '-', 'uploads/1-7.png', 'uploads/1-8.png', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(16, 'sl', 'sdl', 'd@d.com', 'sdkf', 'Priority', 'Not Sure', 'asdas', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(17, 'as', 'sd', 'dc@c.asom', 'asdlas', 'Priority', 'Not Sure', 'Sa\r\nasdas\r\n', 1, 'Logged', '', 'mega_win_20.png', 'mega_win_21.png', 'mega_win_22.png', 'mega_win_23.png', 'mega_win_24.png', 'mega_win_25.png', 'mega_win_26.png', 'mega_win_27.png', 'uploads/1-9.png', 'uploads/1-10.png', 'uploads/1-11.png', 'uploads/1-12.png', 'uploads/1-13.png', 'uploads/1-14.png', 'uploads/1-15.png', 'uploads/1-16.png', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(18, 'qw', '12', 's@2.com', 'sdkjas', 'Priority', 'Not Sure', 'asd\r\nqweqw\r\n', 1, 'Logged', 'asdaswqv qwdasda\r\nas\r\nd\r\nasdqw\r\n\r\nasd', 'tampilan program.jpg', '-', '-', '-', '-', '-', '-', '-', 'uploads/1-1.jpg', '-', '-', '-', '-', '-', '-', '-', 'index.php', '_45_BatteringRam_Attack.png', '_45_BatteringRam_Attack.png.meta', '_45_BatteringRam_Idle.png', '-', '-', '-', '-', 'uploads/admfls-18-1-1.php', 'uploads/admfls-18-1-2.png', 'uploads/admfls-18-1-3.meta', 'uploads/admfls-18-1-4.png', '-', '-', '-', '-', 0, 0, 0, 0, 0, 0),
(20, 'fgdf', 'dfs', 'd@d.com', 'as', 'Priority', 'Not Sure', 'qwd\r\nas', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(21, 'sd', 'qw', 'dA@d.com', 'asd', 'Priority', 'Not Sure', 'sdf', 1, 'Logged', '', '_45_Archer_Attack.png', '_45_Archer_Hitted.png', '_45_Archer_Idle.png', '_45_Archer_Run.png', '_45_Armis_Attack.png', '_45_Armis_Hitted.png', '_45_Armis_Idle.png', '_45_Armis_Run.png', 'uploads/1-17.png', 'uploads/1-18.png', 'uploads/1-19.png', 'uploads/1-20.png', 'uploads/1-21.png', 'uploads/1-22.png', 'uploads/1-23.png', 'uploads/1-24.png', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(22, 'd', 'ds', '2@d.coa', 'asdasd', 'Priority', 'Not Sure', 'asd', 1, 'Logged', '', '1468595497667.jpg', '-', '-', '-', '-', '-', '-', '-', 'uploads/1-2.jpg', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(23, 'gh', 'sd', 'f@f.vom', 'sd', 'Priority', 'Not Sure', 'sdf', 1, 'Logged', '', 'Chrysanthemum.jpg', 'Desert.jpg', 'Hydrangeas.jpg', 'Jellyfish.jpg', 'Koala.jpg', 'Lighthouse.jpg', 'Penguins.jpg', 'Tulips.jpg', 'uploads/1-3.jpg', 'uploads/1-4.jpg', 'uploads/1-5.jpg', 'uploads/1-6.jpg', 'uploads/1-7.jpg', 'uploads/1-8.jpg', 'uploads/1-9.jpg', 'uploads/1-10.jpg', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(24, 'd', 'a', 's@f.vk', 'sdf', 'Priority', 'Not Sure', 'werwe', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(25, 'asda', 'asd', 'dd@d.com', 'asdas', 'Off-Peak', 'Not Sure', 'asdsdfsd', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(26, 'k', 'as', 'd@d.com', 'asd', 'Priority', 'Not Sure', 's', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(27, 's', 'd', 's@d.com', 'asd', 'Priority', 'Not Sure', 'asd', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(28, 's', 's', 's@c.ask', 's', 'Priority', 'Not Sure', 'as', 5, 'Logged', '', 'Jellyfish.jpg', '-', '-', '-', '-', '-', '-', '-', 'uploads/5-1.jpg', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(29, 'd', 'sd', 'd@d.com', 'sdfsd', 'Priority', 'Not Sure', 'sdfsd', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(30, 'd', 'aasa', 'f@c.a', 'asd', 'Off-Peak', 'Not Sure', 'qweqw', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(31, 'dk', 'dhe', 'de@d.coas', 'ksdfsd', 'Priority', 'Not Sure', 'asdas', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(32, 'as', 'asda', 'ds@csa.com', 'asd', 'Off-Peak', 'Not Sure', 'asdasa\r\nasd\r\nasd', 1, 'Logged', 'asd\r\nqwe\r\nasdf\r\n', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'index.php', '', '', '', '', '', '', '', 'uploads/admfls-32-1-1.php', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(33, 'asd', 'qwe', 'df@sd.fsop', 'sdf', 'Off-Peak', 'Not Sure', 'dsdf', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(34, 'asd', 'qwe', 'df@sd.fsop', 'sdf', 'Off-Peak', 'Not Sure', 'dsdf', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(35, 'as', 'asd', 'f@f.asimn', 'sdf', 'Off-Peak', 'Not Sure', 'sdfsd', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(36, 'sdf', 'sd', 'df@sdf.cmk', 'sdf', 'Off-Peak', 'Not Sure', 'sdfsd', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(37, 'sdf', 'd', 'sdf@asd.com', 'sdfjk', 'Priority', 'Not Sure', 'sdfd', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0),
(38, 'asd', 'qweq', 'sdf@sd.aO', 'df', 'Off-Peak', 'Not Sure', 'ASDAS', 1, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1483594219, 0, 0, 0, 0, 0),
(39, 'zc', 'asdas', 'asd@dfsd.co', 'asd', 'Off-Peak', 'Not Sure', 'asdas', 5, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1483594265, 0, 0, 0, 0, 0),
(40, 'sdf', 'srwe', 'sdf@c.ask', 'sdf', 'Priority', 'Not Sure', 'asdas', 10, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1484019848, 0, 0, 0, 0, 0),
(42, 'asd', 'qwe', 's@akas.ao', 'sdf', 'Priority', 'Not Sure', 'asd', 18, 'Logged', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1484980076, 0, 0, 0, 13, 17),
(43, 'de', 'asd', 'd@as.coas', 'asd', 'Priority', 'Not Sure', 'asd\r\n\r\nasd', 18, 'Logged', '', 'tampilan program.jpg', 'Penguins.jpg', 'Koala.jpg', 'Lighthouse.jpg', 'Penguins.jpg', 'Tulips.jpg', 'Jellyfish.jpg', 'Koala.jpg', 'uploads/18-1.jpg', 'uploads/18-2.jpg', 'uploads/18-3.jpg', 'uploads/18-4.jpg', 'uploads/18-5.jpg', 'uploads/18-6.jpg', 'uploads/18-7.jpg', 'uploads/18-8.jpg', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1485067772, 0, 0, 0, 13, 17),
(44, 'asd', 'asqwe', 'sasd@as.co', 'dds', 'Priority', 'Telecommunications', 'asd', 18, 'Closed', '', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 1485080038, 11, 16, 15, 13, 17);

-- --------------------------------------------------------

--
-- Table structure for table `uf_tickets_worklog`
--

CREATE TABLE IF NOT EXISTS `uf_tickets_worklog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `user_name` varchar(150) NOT NULL,
  `time_stamp` varchar(50) NOT NULL,
  `log_content` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=50 ;

--
-- Dumping data for table `uf_tickets_worklog`
--

INSERT INTO `uf_tickets_worklog` (`id`, `ticket_id`, `user_id`, `user_name`, `time_stamp`, `log_content`) VALUES
(1, 32, 1, '', '3/1/17 10:47', 'created'),
(2, 32, 1, '', '3/1/17 10:53', 'admin note updated by iangray:asd\r\nqwe\r\nasdf\r\n'),
(3, 32, 1, '', '3/1/17 10:53', 'admin file index.php uploaded by iangray'),
(4, 10, 1, '', '3/1/17 10:56', 'service level updated to Off-Peak by iangray'),
(5, 10, 1, '', '3/1/17 10:56', 'service type updated to Plumbing by iangray'),
(6, 10, 1, '', '3/1/17 10:56', 'status updated to Awaiting response by iangray'),
(7, 32, 1, 'iangray', '3/1/17 11:02', 'service level updated to Off-Peak by iangray'),
(8, 32, 1, 'iangray', '3/1/17 11:02', 'message updated by iangray : asdasa\r\nasd\r\nasd'),
(9, 33, 1, 'iangray', '3/1/17 21:52', 'created'),
(10, 34, 1, 'iangray', '3/1/17 21:53', 'created'),
(11, 35, 1, 'iangray', '3/1/17 21:53', 'created'),
(12, 36, 1, 'iangray', '3/1/17 21:54', 'created'),
(13, 37, 1, 'iangray', '3/1/17 21:54', 'created'),
(14, 38, 1, 'iangray', '5/1/17 00:30', 'created'),
(15, 39, 5, 'regionalmanager', '5/1/17 00:31', 'created'),
(16, 40, 10, 'proservadmin', '9/1/17 22:44', 'created'),
(17, 3, 1, 'user2', '18/1/17 00:48', 'admin note updated by user2 : '),
(18, 3, 1, 'user2', '18/1/17 00:51', 'status updated to Completed by user2'),
(19, 3, 1, 'user1', '18/1/17 01:04', 'status updated to Assigned by user1'),
(20, 3, 1, 'user2', '18/1/17 01:06', 'status updated to Completed by user2'),
(21, 3, 1, 'user1', '18/1/17 01:07', 'status updated to Assigned by user1'),
(22, 3, 1, 'user2', '18/1/17 01:08', 'status updated to Completed by user2'),
(23, 3, 1, 'user1', '18/1/17 01:09', 'status updated to Closed by user1'),
(24, 3, 1, 'proservadmin', '18/1/17 03:12', 'status updated to Invoiced by proservadmin'),
(25, 3, 1, 'proservadmin', '18/1/17 22:21', 'status updated to Paid by proservadmin'),
(26, 41, 18, 'user4', '21/1/17 01:07', 'created'),
(27, 42, 18, 'user4', '21/1/17 01:27', 'created'),
(28, 43, 18, 'user4', '22/1/17 01:49', 'created by user4'),
(29, 43, 18, 'user3', '22/1/17 03:24', 'message updated by user3 : asd\r\n\r\nasd\r\nas\r\ndas\r\nqw'),
(30, 43, 18, 'user3', '22/1/17 03:24', 'message updated by user3 : asd\r\n\r\nasd'),
(31, 43, 18, 'user3', '22/1/17 03:42', 'User file Penguins.jpg uploaded by user3'),
(32, 43, 18, 'user3', '22/1/17 03:42', 'User file Koala.jpg uploaded by user3'),
(33, 43, 18, 'user3', '22/1/17 03:42', 'User file Lighthouse.jpg uploaded by user3'),
(34, 43, 18, 'user3', '22/1/17 03:42', 'User file Penguins.jpg uploaded by user3'),
(35, 43, 18, 'user3', '22/1/17 03:42', 'User file Tulips.jpg uploaded by user3'),
(36, 43, 18, 'user3', '22/1/17 03:49', 'User file Jellyfish.jpg uploaded by user3'),
(37, 43, 18, 'user3', '22/1/17 03:49', 'User file Koala.jpg uploaded by user3'),
(38, 44, 18, 'user4', '22/1/17 05:13', 'created by user4'),
(39, 44, 18, 'proservadmin', '22/1/17 05:21', '#44 allocated to provider1 by proservadmin'),
(40, 44, 18, 'proservadmin', '22/1/17 05:22', '#44 allocated to provider1 by proservadmin'),
(41, 44, 18, 'provider1', '22/1/17 05:25', '#44 allocated to user1 by provider1'),
(42, 44, 18, 'user1', '22/1/17 05:26', '#44 assigned to user2 by user1'),
(43, 44, 18, 'user2', '22/1/17 05:27', 'status updated to Completed by user2'),
(44, 44, 18, 'user1', '22/1/17 05:32', 'status updated to Closed by user1'),
(45, 44, 18, 'user1', '22/1/17 05:36', 'status updated to Closed by user1'),
(46, 44, 18, 'user1', '22/1/17 06:10', 'status updated to Closed by user1'),
(47, 4, 1, 'proservadmin', '24/1/17 03:36', '#4 allocated to provider1 by proservadmin'),
(48, 4, 1, 'provider1', '24/1/17 03:36', '#4 allocated to user1 by provider1'),
(49, 4, 1, 'user1', '24/1/17 03:37', '#4 assigned to user2 by user1');

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
  `provider_organisation_id` int(11) NOT NULL,
  `provider_admin_id` int(11) NOT NULL,
  `user_organisation_id` int(11) NOT NULL,
  `user_admin_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25 ;

--
-- Dumping data for table `uf_user`
--

INSERT INTO `uf_user` (`id`, `user_name`, `display_name`, `email`, `title`, `locale`, `primary_group_id`, `secret_token`, `flag_verified`, `flag_enabled`, `flag_password_reset`, `created_at`, `updated_at`, `password`, `provider_organisation_id`, `provider_admin_id`, `user_organisation_id`, `user_admin_id`) VALUES
(1, 'iangray', 'Ian Gray', 'ian@clevertangent.com', 'New User', 'en_US', 2, '', 1, 1, 0, '2016-12-03 06:15:22', '2016-12-17 21:43:25', '$2y$10$.4/B93iuSzrDHrhj2gfGLO3FRPtRgo1zQyThZOQmfw/qDHZavB3GS', 0, 0, 0, 0),
(5, 'regionalmanager', 'Regional Manager', 'ian.gray@ptsg.com.au', 'Manager', 'en_US', 1, '3a6d4323cd5dd0d7fdf9241d901ffe31', 1, 1, 0, '2016-12-04 15:46:12', '2016-12-10 19:02:08', '$2y$10$MObDDsWn8E.by0S9S0nTbeAGyaSeRSYKj.pUNxPdHuSV6nmivSkue', 0, 0, 0, 0),
(7, 'Paul Lyon', 'Paul Lyon', 'paul.lyon@paltechservices.com.au', 'New User', 'en_US', 1, '8225b0c24cc6cd0178cf72126b02954e', 1, 1, 0, '2016-12-12 22:56:02', '2016-12-12 22:56:32', '$2y$10$Zqjh8Nwllz/x3SsZoWI4KOK4SK9r.Zs/hfkFrgRLTQtGbljqXY.Gm', 0, 0, 0, 0),
(8, 'Dean Deighton', 'Dean D', 'dean@2dstrategics.com.au', 'New User', 'en_US', 1, '6a7cbd394eb07d69de80e4bf1b7e5c61', 1, 1, 0, '2016-12-13 00:28:55', '2016-12-13 00:29:41', '$2y$10$cSpNyRLkBFZ29alyDkR4t.dCkCHScNDUGyv7BHkuheGQiERA.Wi/q', 0, 0, 0, 0),
(9, 'Ross', 'Abergowrie Elec', 'abergowrieelec@itnq.com.au', 'New User', 'en_US', 1, '0ba7ef8ed04185268e9a1e23f9b5f096', 1, 1, 0, '2016-12-13 15:39:19', '2016-12-13 15:42:06', '$2y$10$tm77Yqvy.fEEPom.pDcwPuOE75bEc.7kXAwc3TyTcZ3ZUjLePzsim', 0, 0, 0, 0),
(10, 'proservadmin', 'proservadmin', 'a@1.com', 'proservadmin', 'en_US', 4, '9ef88c7df736a67245d71cc560f505bf', 1, 1, 1, '2017-01-07 21:37:32', '2017-01-07 21:47:39', '$2y$10$sl5htfIRvdvaHe2GpjQ1Ueb9bjU7xsOPdp..BHgS5uNHoHjFdTwVy', 0, 0, 0, 0),
(11, 'provider1', 'provider1', 'dede1488@gmail.com', 'Provider Organisation', 'en_US', 5, '367e186a19687a6ad74da55a7b3d4e23', 1, 1, 1, '2017-01-09 14:08:17', '2017-01-09 15:32:29', '$2y$10$wT1BrJ09hsFUHbA3.9P31OrqZIwHcZ5yKWsiA4lSqS0d0OYvm/tl.', 0, 0, 0, 0),
(12, 'provider2', 'provider2', 'provider@2.com', 'Provider Organisation', 'en_US', 5, '64839348d79869bb55fb3df97d7caf30', 1, 1, 1, '2017-01-09 14:08:37', '2017-01-09 15:42:07', '$2y$10$uLuz21Y3b6U4PRwmqjI5xuciyv2XxkXBNa7PSgQM/IVPK5MCW8gzK', 0, 0, 0, 0),
(13, 'clientorg1', 'clientorg1', 'clientorg@1.com', 'User Organisation', 'en_US', 8, 'e4697f3f539ae885bc13c2592143269e', 1, 1, 1, '2017-01-09 14:09:14', '2017-01-09 15:42:23', '$2y$10$EoYOOewUJtH1DU5MB8rcZuCITbpRbvqDSdzr3zyWHkVYzOY6jGRbe', 0, 0, 0, 0),
(14, 'clientorg2', 'clientorg2', 'clientorg@2.com', 'User Organisation', 'en_US', 8, 'c37e16e3943b28e68a7a9965f3d96d12', 1, 1, 1, '2017-01-09 14:10:32', '2017-01-09 15:42:33', '$2y$10$mlLex38bpz/ivkdxb7QLEeb1X6dwEAPQ6zsCk0aeqNJZyrCg3Wuf.', 0, 0, 0, 0),
(15, 'user1', 'user1', 'dede1488@gmail.com', 'New User', 'en_US', 6, 'e114a66e0523984bf6e4f8db2494ba80', 1, 1, 1, '2017-01-09 14:10:56', '2017-01-16 18:08:23', '$2y$10$vMGZzcv4gjlnI/J1Ft/UIusQO5zJAIlwEHJ8P1tdWbQo4LlCmIYj2', 11, 0, 0, 0),
(16, 'user2', 'user2', 'dede1488@gmail.com', 'New User', 'en_US', 7, '64d9d2ae49704c709f14faab6c4a3aae', 1, 1, 1, '2017-01-09 14:11:11', '2017-01-16 18:09:37', '$2y$10$L7wFs2RN5dQU1DynJdkWpuxZpTJ7nYJvthUTfQNvUJEvIQVgZBH4m', 11, 15, 0, 0),
(17, 'user3', 'user3', 'user@3.com', 'New User', 'en_US', 9, '05073bdc78a9d8de3c97321f5f6b925e', 1, 1, 1, '2017-01-09 14:11:27', '2017-01-19 14:37:06', '$2y$10$KpRgZJU0qLbOO.TsFNAigOqbWgkD5Aj2JGdHcgw72f7i9Jtf4l9nC', 0, 0, 13, 0),
(18, 'user4', 'user4', 'dede1488@gmail.com', 'New User', 'en_US', 1, '39eee85f73b3e9112a0dcb36d816a83b', 1, 1, 1, '2017-01-09 14:11:58', '2017-01-19 14:39:08', '$2y$10$SJhuo91E7ac18B4gD58uOemPL571aQgkyZRHIHgAsGopqad5hAcC2', 0, 0, 13, 17),
(19, 'user5', 'user5', 'user@5.com', 'New User', 'en_US', 1, '4aeecf4d4ad1415bc427ac12dc2307ab', 1, 1, 1, '2017-01-09 14:13:58', '2017-01-09 15:25:04', '$2y$10$c6LBJbawp8UiwBYbFJfDke28xyagg.Kwi4vYuPpBkzIYd7N/a7squ', 0, 0, 0, 0),
(20, 'user6', 'user6', 'user@6.com', 'New User', 'en_US', 1, '081dfc096a4947eb9258fd5325bb3356', 1, 1, 1, '2017-01-09 14:14:13', '2017-01-09 15:25:42', '$2y$10$VZWJErcXS6sYZH/UEYJjW.Z0cKO6pXIDD1pbrSZWozRKl1WIotocC', 0, 0, 0, 0),
(21, 'user7', 'user7', 'user@7.com', 'New User', 'en_US', 1, '02864627172f95adae59a4ba0139668a', 1, 1, 1, '2017-01-09 14:14:27', '2017-01-09 15:25:57', '$2y$10$PNx0OgwI5D4smaCmd5XKhuID53.DU.fi7QrLUjJ4ZzL/oZRZrgGcS', 0, 0, 0, 0),
(22, 'user8', 'user8', 'user@8.com', 'New User', 'en_US', 1, 'b27f1c8d930012521059ee7e96d1a8fc', 1, 1, 1, '2017-01-09 14:14:42', '2017-01-09 15:28:04', '$2y$10$ThNH9QdCbK81ChYbdNhgfO7ae7yLn.o8cFxVmqkPnRU189bhTW5Da', 0, 0, 0, 0),
(23, 'user9', 'user9', 'user@9.com', 'New User', 'en_US', 1, '9220231421ff792ccd31f7e3ff1be79a', 1, 1, 1, '2017-01-09 14:14:57', '2017-01-09 15:29:08', '$2y$10$kA0v7ISW/Ft5S1Bbusbwxun1avzq0su3nYv7SqYeKGxIPYtQxTZom', 0, 0, 0, 0),
(24, 'user10', 'user10', 'user@10.com', 'New User', 'en_US', 1, 'd633e2e59acd0d1e7928c49a874af695', 1, 1, 1, '2017-01-09 14:15:16', '2017-01-09 15:29:21', '$2y$10$cv29VTReW9oR9xQA8.hhk.x5TklTYO.DjDAIfUBuuL68RwIi7hNFG', 0, 0, 0, 0);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=268 ;

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
(126, 1, 'sign_in', '2017-01-03 08:07:40', 'User iangray signed in at 2017-01-03 03:07:40.'),
(127, 1, 'sign_in', '2017-01-04 02:23:41', 'User iangray signed in at 2017-01-03 21:23:41.'),
(128, 5, 'sign_in', '2017-01-04 03:19:58', 'User regionalmanager signed in at 2017-01-03 22:19:58.'),
(129, 1, 'sign_in', '2017-01-05 04:55:31', 'User iangray signed in at 2017-01-04 23:55:31.'),
(130, 5, 'sign_in', '2017-01-05 05:30:47', 'User regionalmanager signed in at 2017-01-05 00:30:47.'),
(131, 1, 'sign_in', '2017-01-05 05:31:27', 'User iangray signed in at 2017-01-05 00:31:27.'),
(132, 1, 'sign_in', '2017-01-08 08:35:05', 'User iangray signed in at 2017-01-08 03:35:05.'),
(133, 10, 'sign_up', '2017-01-08 09:37:33', 'User proservadmin was created by iangray on 2017-01-08 04:37:32.'),
(134, 10, 'password_reset_request', '2017-01-08 09:37:33', 'User proservadmin requested a password reset on 2017-01-08 04:37:32.'),
(135, 1, 'sign_in', '2017-01-08 09:40:56', 'User iangray signed in at 2017-01-08 04:40:56.'),
(136, 10, 'sign_in', '2017-01-08 09:41:55', 'User proservadmin signed in at 2017-01-08 04:41:55.'),
(137, 1, 'sign_in', '2017-01-08 09:43:56', 'User iangray signed in at 2017-01-08 04:43:56.'),
(138, 10, 'sign_in', '2017-01-08 09:45:03', 'User proservadmin signed in at 2017-01-08 04:45:03.'),
(139, 1, 'sign_in', '2017-01-08 09:46:56', 'User iangray signed in at 2017-01-08 04:46:56.'),
(140, 10, 'sign_in', '2017-01-08 09:48:33', 'User proservadmin signed in at 2017-01-08 04:48:33.'),
(141, 10, 'sign_in', '2017-01-09 02:24:38', 'User proservadmin signed in at 2017-01-08 21:24:38.'),
(142, 1, 'sign_in', '2017-01-10 02:07:21', 'User iangray signed in at 2017-01-09 21:07:21.'),
(143, 11, 'sign_up', '2017-01-10 02:08:17', 'User provider1 was created by iangray on 2017-01-09 21:08:17.'),
(144, 11, 'password_reset_request', '2017-01-10 02:08:17', 'User provider1 requested a password reset on 2017-01-09 21:08:17.'),
(145, 12, 'sign_up', '2017-01-10 02:08:37', 'User provider2 was created by iangray on 2017-01-09 21:08:37.'),
(146, 12, 'password_reset_request', '2017-01-10 02:08:37', 'User provider2 requested a password reset on 2017-01-09 21:08:37.'),
(147, 13, 'sign_up', '2017-01-10 02:09:14', 'User clientorg1 was created by iangray on 2017-01-09 21:09:14.'),
(148, 13, 'password_reset_request', '2017-01-10 02:09:14', 'User clientorg1 requested a password reset on 2017-01-09 21:09:14.'),
(149, 14, 'sign_up', '2017-01-10 02:10:32', 'User clientorg2 was created by iangray on 2017-01-09 21:10:32.'),
(150, 14, 'password_reset_request', '2017-01-10 02:10:32', 'User clientorg2 requested a password reset on 2017-01-09 21:10:32.'),
(151, 15, 'sign_up', '2017-01-10 02:10:56', 'User user1 was created by iangray on 2017-01-09 21:10:56.'),
(152, 15, 'password_reset_request', '2017-01-10 02:10:56', 'User user1 requested a password reset on 2017-01-09 21:10:56.'),
(153, 16, 'sign_up', '2017-01-10 02:11:12', 'User user2 was created by iangray on 2017-01-09 21:11:11.'),
(154, 16, 'password_reset_request', '2017-01-10 02:11:12', 'User user2 requested a password reset on 2017-01-09 21:11:11.'),
(155, 17, 'sign_up', '2017-01-10 02:11:27', 'User user3 was created by iangray on 2017-01-09 21:11:27.'),
(156, 17, 'password_reset_request', '2017-01-10 02:11:27', 'User user3 requested a password reset on 2017-01-09 21:11:27.'),
(157, 18, 'sign_up', '2017-01-10 02:11:58', 'User user4 was created by iangray on 2017-01-09 21:11:58.'),
(158, 18, 'password_reset_request', '2017-01-10 02:11:58', 'User user4 requested a password reset on 2017-01-09 21:11:58.'),
(159, 19, 'sign_up', '2017-01-10 02:13:58', 'User user5 was created by iangray on 2017-01-09 21:13:58.'),
(160, 19, 'password_reset_request', '2017-01-10 02:13:58', 'User user5 requested a password reset on 2017-01-09 21:13:58.'),
(161, 20, 'sign_up', '2017-01-10 02:14:13', 'User user6 was created by iangray on 2017-01-09 21:14:13.'),
(162, 20, 'password_reset_request', '2017-01-10 02:14:13', 'User user6 requested a password reset on 2017-01-09 21:14:13.'),
(163, 21, 'sign_up', '2017-01-10 02:14:27', 'User user7 was created by iangray on 2017-01-09 21:14:27.'),
(164, 21, 'password_reset_request', '2017-01-10 02:14:27', 'User user7 requested a password reset on 2017-01-09 21:14:27.'),
(165, 22, 'sign_up', '2017-01-10 02:14:42', 'User user8 was created by iangray on 2017-01-09 21:14:42.'),
(166, 22, 'password_reset_request', '2017-01-10 02:14:42', 'User user8 requested a password reset on 2017-01-09 21:14:42.'),
(167, 23, 'sign_up', '2017-01-10 02:14:57', 'User user9 was created by iangray on 2017-01-09 21:14:57.'),
(168, 23, 'password_reset_request', '2017-01-10 02:14:57', 'User user9 requested a password reset on 2017-01-09 21:14:57.'),
(169, 24, 'sign_up', '2017-01-10 02:15:17', 'User user10 was created by iangray on 2017-01-09 21:15:16.'),
(170, 24, 'password_reset_request', '2017-01-10 02:15:17', 'User user10 requested a password reset on 2017-01-09 21:15:16.'),
(171, 11, 'sign_in', '2017-01-10 03:43:31', 'User provider1 signed in at 2017-01-09 22:43:31.'),
(172, 10, 'sign_in', '2017-01-10 03:43:51', 'User proservadmin signed in at 2017-01-09 22:43:51.'),
(173, 10, 'sign_in', '2017-01-10 04:38:40', 'User proservadmin signed in at 2017-01-09 23:38:40.'),
(174, 10, 'sign_in', '2017-01-11 05:50:38', 'User proservadmin signed in at 2017-01-11 00:50:38.'),
(175, 11, 'sign_in', '2017-01-11 08:14:14', 'User provider1 signed in at 2017-01-11 03:14:14.'),
(176, 11, 'sign_in', '2017-01-12 02:59:11', 'User provider1 signed in at 2017-01-11 21:59:11.'),
(177, 11, 'sign_in', '2017-01-13 02:34:02', 'User provider1 signed in at 2017-01-12 21:34:02.'),
(178, 11, 'sign_in', '2017-01-15 11:28:44', 'User provider1 signed in at 2017-01-15 06:28:44.'),
(179, 15, 'sign_in', '2017-01-15 11:29:55', 'User user1 signed in at 2017-01-15 06:29:55.'),
(180, 11, 'sign_in', '2017-01-15 15:04:13', 'User provider1 signed in at 2017-01-15 10:04:13.'),
(181, 11, 'sign_in', '2017-01-15 15:15:05', 'User provider1 signed in at 2017-01-15 10:15:05.'),
(182, 15, 'sign_in', '2017-01-15 15:16:36', 'User user1 signed in at 2017-01-15 10:16:36.'),
(183, 15, 'sign_in', '2017-01-16 04:16:09', 'User user1 signed in at 2017-01-15 23:16:09.'),
(184, 11, 'sign_in', '2017-01-16 04:31:13', 'User provider1 signed in at 2017-01-15 23:31:13.'),
(185, 11, 'sign_in', '2017-01-17 03:11:58', 'User provider1 signed in at 2017-01-16 22:11:58.'),
(186, 16, 'sign_in', '2017-01-17 03:33:35', 'User user2 signed in at 2017-01-16 22:33:35.'),
(187, 11, 'sign_in', '2017-01-17 03:38:04', 'User provider1 signed in at 2017-01-16 22:38:04.'),
(188, 15, 'sign_in', '2017-01-17 04:18:50', 'User user1 signed in at 2017-01-16 23:18:50.'),
(189, 11, 'sign_in', '2017-01-17 04:51:19', 'User provider1 signed in at 2017-01-16 23:51:19.'),
(190, 15, 'sign_in', '2017-01-17 05:42:11', 'User user1 signed in at 2017-01-17 00:42:11.'),
(191, 15, 'sign_in', '2017-01-17 05:54:27', 'User user1 signed in at 2017-01-17 00:54:27.'),
(192, 1, 'sign_in', '2017-01-17 05:57:02', 'User iangray signed in at 2017-01-17 00:57:02.'),
(193, 11, 'sign_in', '2017-01-17 06:08:00', 'User provider1 signed in at 2017-01-17 01:08:00.'),
(194, 15, 'sign_in', '2017-01-17 06:08:18', 'User user1 signed in at 2017-01-17 01:08:18.'),
(195, 11, 'sign_in', '2017-01-17 06:09:14', 'User provider1 signed in at 2017-01-17 01:09:14.'),
(196, 16, 'sign_in', '2017-01-17 06:09:33', 'User user2 signed in at 2017-01-17 01:09:33.'),
(197, 10, 'sign_in', '2017-01-17 06:09:50', 'User proservadmin signed in at 2017-01-17 01:09:50.'),
(198, 11, 'sign_in', '2017-01-17 06:11:08', 'User provider1 signed in at 2017-01-17 01:11:08.'),
(199, 15, 'sign_in', '2017-01-17 06:11:28', 'User user1 signed in at 2017-01-17 01:11:28.'),
(200, 16, 'sign_in', '2017-01-17 08:02:05', 'User user2 signed in at 2017-01-17 03:02:05.'),
(201, 16, 'sign_in', '2017-01-18 03:37:40', 'User user2 signed in at 2017-01-17 22:37:40.'),
(202, 15, 'sign_in', '2017-01-18 05:54:10', 'User user1 signed in at 2017-01-18 00:54:10.'),
(203, 16, 'sign_in', '2017-01-18 06:06:11', 'User user2 signed in at 2017-01-18 01:06:11.'),
(204, 15, 'sign_in', '2017-01-18 06:06:42', 'User user1 signed in at 2017-01-18 01:06:42.'),
(205, 16, 'sign_in', '2017-01-18 06:08:38', 'User user2 signed in at 2017-01-18 01:08:38.'),
(206, 15, 'sign_in', '2017-01-18 06:09:04', 'User user1 signed in at 2017-01-18 01:09:04.'),
(207, 10, 'sign_in', '2017-01-18 06:09:33', 'User proservadmin signed in at 2017-01-18 01:09:33.'),
(208, 10, 'sign_in', '2017-01-19 03:19:51', 'User proservadmin signed in at 2017-01-18 22:19:51.'),
(209, 10, 'sign_in', '2017-01-19 06:09:47', 'User proservadmin signed in at 2017-01-19 01:09:47.'),
(210, 15, 'sign_in', '2017-01-19 06:20:09', 'User user1 signed in at 2017-01-19 01:20:09.'),
(211, 1, 'sign_in', '2017-01-19 06:21:13', 'User iangray signed in at 2017-01-19 01:21:13.'),
(212, 1, 'sign_in', '2017-01-19 06:23:16', 'User iangray signed in at 2017-01-19 01:23:16.'),
(213, 1, 'sign_in', '2017-01-19 06:40:31', 'User iangray signed in at 2017-01-19 01:40:31.'),
(214, 13, 'sign_in', '2017-01-19 07:06:49', 'User clientorg1 signed in at 2017-01-19 02:06:49.'),
(215, 13, 'sign_in', '2017-01-20 02:24:55', 'User clientorg1 signed in at 2017-01-19 21:24:55.'),
(216, 17, 'sign_in', '2017-01-20 02:37:02', 'User user3 signed in at 2017-01-19 21:37:02.'),
(217, 13, 'sign_in', '2017-01-20 02:37:24', 'User clientorg1 signed in at 2017-01-19 21:37:24.'),
(218, 18, 'sign_in', '2017-01-20 02:39:05', 'User user4 signed in at 2017-01-19 21:39:05.'),
(219, 17, 'sign_in', '2017-01-20 02:39:18', 'User user3 signed in at 2017-01-19 21:39:18.'),
(220, 15, 'sign_in', '2017-01-20 09:05:45', 'User user1 signed in at 2017-01-20 04:05:45.'),
(221, 17, 'sign_in', '2017-01-21 03:46:13', 'User user3 signed in at 2017-01-20 22:46:13.'),
(222, 18, 'sign_in', '2017-01-21 06:07:39', 'User user4 signed in at 2017-01-21 01:07:39.'),
(223, 17, 'sign_in', '2017-01-21 06:15:41', 'User user3 signed in at 2017-01-21 01:15:41.'),
(224, 18, 'sign_in', '2017-01-21 06:27:44', 'User user4 signed in at 2017-01-21 01:27:44.'),
(225, 17, 'sign_in', '2017-01-21 06:28:14', 'User user3 signed in at 2017-01-21 01:28:14.'),
(226, 1, 'sign_in', '2017-01-21 07:28:57', 'User iangray signed in at 2017-01-21 02:28:57.'),
(227, 1, 'sign_in', '2017-01-22 03:36:24', 'User iangray signed in at 2017-01-21 22:36:24.'),
(228, 11, 'sign_in', '2017-01-22 03:40:38', 'User provider1 signed in at 2017-01-21 22:40:38.'),
(229, 15, 'sign_in', '2017-01-22 04:33:19', 'User user1 signed in at 2017-01-21 23:33:19.'),
(230, 17, 'sign_in', '2017-01-22 04:33:57', 'User user3 signed in at 2017-01-21 23:33:57.'),
(231, 13, 'sign_in', '2017-01-22 04:34:32', 'User clientorg1 signed in at 2017-01-21 23:34:32.'),
(232, 1, 'sign_in', '2017-01-22 05:12:54', 'User iangray signed in at 2017-01-22 00:12:54.'),
(233, 17, 'sign_in', '2017-01-22 05:46:19', 'User user3 signed in at 2017-01-22 00:46:19.'),
(234, 18, 'sign_in', '2017-01-22 06:48:38', 'User user4 signed in at 2017-01-22 01:48:38.'),
(235, 17, 'sign_in', '2017-01-22 06:49:51', 'User user3 signed in at 2017-01-22 01:49:51.'),
(236, 10, 'sign_in', '2017-01-22 09:28:47', 'User proservadmin signed in at 2017-01-22 04:28:47.'),
(237, 18, 'sign_in', '2017-01-22 10:13:27', 'User user4 signed in at 2017-01-22 05:13:27.'),
(238, 10, 'sign_in', '2017-01-22 10:14:16', 'User proservadmin signed in at 2017-01-22 05:14:16.'),
(239, 11, 'sign_in', '2017-01-22 10:25:35', 'User provider1 signed in at 2017-01-22 05:25:35.'),
(240, 15, 'sign_in', '2017-01-22 10:26:16', 'User user1 signed in at 2017-01-22 05:26:16.'),
(241, 16, 'sign_in', '2017-01-22 10:27:16', 'User user2 signed in at 2017-01-22 05:27:16.'),
(242, 15, 'sign_in', '2017-01-22 10:28:46', 'User user1 signed in at 2017-01-22 05:28:46.'),
(243, 15, 'sign_in', '2017-01-22 10:35:41', 'User user1 signed in at 2017-01-22 05:35:41.'),
(244, 13, 'sign_in', '2017-01-24 03:15:02', 'User clientorg1 signed in at 2017-01-23 22:15:02.'),
(245, 15, 'sign_in', '2017-01-24 03:21:36', 'User user1 signed in at 2017-01-23 22:21:36.'),
(246, 10, 'sign_in', '2017-01-24 03:57:49', 'User proservadmin signed in at 2017-01-23 22:57:49.'),
(247, 11, 'sign_in', '2017-01-24 03:58:13', 'User provider1 signed in at 2017-01-23 22:58:13.'),
(248, 19, 'sign_in', '2017-01-24 07:03:56', 'User user5 signed in at 2017-01-24 02:03:56.'),
(249, 13, 'sign_in', '2017-01-24 07:56:01', 'User clientorg1 signed in at 2017-01-24 02:56:01.'),
(250, 19, 'sign_in', '2017-01-24 07:56:24', 'User user5 signed in at 2017-01-24 02:56:24.'),
(251, 13, 'sign_in', '2017-01-24 07:59:52', 'User clientorg1 signed in at 2017-01-24 02:59:52.'),
(252, 11, 'sign_in', '2017-01-24 08:35:39', 'User provider1 signed in at 2017-01-24 03:35:39.'),
(253, 10, 'sign_in', '2017-01-24 08:36:10', 'User proservadmin signed in at 2017-01-24 03:36:10.'),
(254, 11, 'sign_in', '2017-01-24 08:36:32', 'User provider1 signed in at 2017-01-24 03:36:32.'),
(255, 15, 'sign_in', '2017-01-24 08:36:55', 'User user1 signed in at 2017-01-24 03:36:55.'),
(256, 16, 'sign_in', '2017-01-24 08:37:12', 'User user2 signed in at 2017-01-24 03:37:12.'),
(257, 15, 'sign_in', '2017-01-24 08:37:26', 'User user1 signed in at 2017-01-24 03:37:26.'),
(258, 16, 'sign_in', '2017-01-24 08:37:45', 'User user2 signed in at 2017-01-24 03:37:45.'),
(259, 11, 'sign_in', '2017-01-24 09:25:54', 'User provider1 signed in at 2017-01-24 04:25:54.'),
(260, 11, 'sign_in', '2017-01-25 03:20:38', 'User provider1 signed in at 2017-01-24 22:20:38.'),
(261, 1, 'sign_in', '2017-03-03 03:57:56', 'User iangray signed in at 2017-03-02 22:57:56.'),
(262, 1, 'sign_in', '2017-03-03 04:05:35', 'User iangray signed in at 2017-03-02 23:05:35.'),
(263, 1, 'sign_in', '2017-03-03 04:09:14', 'User iangray signed in at 2017-03-02 23:09:14.'),
(264, 1, 'sign_in', '2017-03-03 04:42:50', 'User iangray signed in at 2017-03-02 23:42:49.'),
(265, 1, 'sign_in', '2017-03-08 05:56:58', 'User iangray signed in at 2017-03-08 00:56:58.'),
(266, 1, 'sign_in', '2017-03-09 06:08:10', 'User iangray signed in at 2017-03-09 01:08:10.'),
(267, 1, 'sign_in', '2017-03-10 06:12:07', 'User iangray signed in at 2017-03-10 01:12:07.');

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
