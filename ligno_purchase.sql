-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 18, 2020 at 04:52 AM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ligno_purchase`
--

-- --------------------------------------------------------

--
-- Table structure for table `po`
--

CREATE TABLE `po` (
  `po_id` varchar(128) NOT NULL,
  `user_id` int(11) NOT NULL,
  `vendor` varchar(128) NOT NULL,
  `po_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `spp`
--

CREATE TABLE `spp` (
  `spp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'yang mengajukan spp',
  `create_at` datetime NOT NULL COMMENT 'tgl pembuatan',
  `item` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `unit` varchar(32) NOT NULL,
  `deadline` date NOT NULL,
  `description` text NOT NULL,
  `manager_approve` int(11) NOT NULL,
  `purch_manager_approve` int(11) NOT NULL,
  `handle_by` int(11) DEFAULT NULL COMMENT 'user_id dari purchasing',
  `po_id` varchar(64) NOT NULL,
  `price` varchar(64) NOT NULL,
  `currency` varchar(32) NOT NULL,
  `est_arrival` date NOT NULL,
  `coa` int(11) NOT NULL COMMENT 'apakah coa sudah diterima?',
  `is_received` int(11) NOT NULL COMMENT '0: no, 1: partial, 2: full',
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `spp_history`
--

CREATE TABLE `spp_history` (
  `history_id` int(11) NOT NULL,
  `spp_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `create_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `dept` varchar(32) NOT NULL,
  `username` varchar(32) NOT NULL,
  `password` varchar(64) NOT NULL,
  `manager_id` int(11) NOT NULL COMMENT 'user_id',
  `is_manager` int(11) NOT NULL DEFAULT 0,
  `is_purchasing` int(11) NOT NULL DEFAULT 0,
  `is_purch_manager` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `po`
--
ALTER TABLE `po`
  ADD PRIMARY KEY (`po_id`);

--
-- Indexes for table `spp`
--
ALTER TABLE `spp`
  ADD PRIMARY KEY (`spp_id`);

--
-- Indexes for table `spp_history`
--
ALTER TABLE `spp_history`
  ADD PRIMARY KEY (`history_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `spp`
--
ALTER TABLE `spp`
  MODIFY `spp_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `spp_history`
--
ALTER TABLE `spp_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
