-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 15, 2020 at 10:17 AM
-- Server version: 10.1.39-MariaDB
-- PHP Version: 7.3.5

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
  `po_date` date NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `po`
--

INSERT INTO `po` (`po_id`, `user_id`, `vendor`, `po_date`, `create_at`) VALUES
('LSC/2020/PO/02', 4, 'PT Sinar Dunia', '2020-10-17', '2020-10-14 15:37:57'),
('LSC/2020/PO/03', 5, 'CV KARYA HUTAMA', '2020-10-18', '2020-10-14 15:45:34'),
('NON-PO/20', 4, 'PT Agra', '2020-10-31', '2020-10-15 14:20:34'),
('PO/999', 1, 'PT x', '2020-10-31', '2020-10-15 14:32:34');

-- --------------------------------------------------------

--
-- Table structure for table `spp`
--

CREATE TABLE `spp` (
  `spp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'yang mengajukan spp',
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'tgl pembuatan',
  `item` varchar(128) NOT NULL,
  `qty` int(11) NOT NULL,
  `unit` varchar(32) NOT NULL,
  `deadline` date NOT NULL,
  `description` text NOT NULL,
  `manager_approve` int(11) NOT NULL,
  `purch_manager_approve` int(11) NOT NULL,
  `purch_manager_cancel` int(11) NOT NULL,
  `handle_by` int(11) DEFAULT NULL COMMENT 'user_id dari purchasing',
  `po_id` varchar(64) DEFAULT NULL,
  `price` varchar(64) NOT NULL,
  `currency` varchar(32) NOT NULL,
  `est_arrival` date DEFAULT NULL,
  `coa` int(11) NOT NULL COMMENT 'apakah coa sudah diterima?',
  `is_received` int(11) NOT NULL COMMENT '0: no, 1: partial, 2: full',
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `spp`
--

INSERT INTO `spp` (`spp_id`, `user_id`, `create_at`, `item`, `qty`, `unit`, `deadline`, `description`, `manager_approve`, `purch_manager_approve`, `purch_manager_cancel`, `handle_by`, `po_id`, `price`, `currency`, `est_arrival`, `coa`, `is_received`, `note`) VALUES
(15, 5, '2020-10-14 15:04:09', 'Kertas A4', 4, 'rim', '2020-10-18', 'Ukuran 80 Gsm', 1, 1, 0, 4, 'LSC/2020/PO/02', '150000', 'IDR', '2020-10-17', 1, 0, 'coa sudah ada'),
(16, 5, '2020-10-14 15:05:18', 'Bolpen Pilot', 3, 'pack', '2020-10-18', 'Warna Hitam', -1, 0, 0, NULL, NULL, '', '', NULL, 0, 0, 'Sudah beli 5 pack sedang dikirim'),
(17, 9, '2020-10-14 15:39:40', 'Helm Safety', 5, 'buah', '2020-10-18', 'Dipakai saat trial ke customer', 1, 1, 0, 5, 'LSC/2020/PO/03', '640000', 'IDR', '2020-10-17', 0, 2, ''),
(18, 9, '2020-10-14 15:40:31', 'Sticky Note', 4, 'buah', '2020-10-17', 'warna hijau', 1, 1, 1, 1, NULL, '', '', NULL, 0, 0, 'sudah tidak butuh'),
(19, 8, '2020-10-14 15:42:19', 'Wearpack', 5, 'buah', '2020-10-18', 'Ukuran XL', 1, 1, 0, 5, 'LSC/2020/PO/03', '750000', 'IDR', '2020-10-17', 0, 1, ''),
(20, 8, '2020-10-14 16:18:08', 'Sticky Note', 5, 'unit', '2020-10-15', 'Warna kuning', 1, 1, 0, 4, 'NON-PO/20', '20000', 'IDR', '2020-10-16', 1, 2, ''),
(21, 8, '2020-10-14 16:21:02', 'Kursi Kerja', 2, 'unit', '2020-10-18', 'U\nKursi standar untuk merketing', 1, 1, 0, 5, 'PO/999', '600000', 'IDR', '2020-10-16', 0, 0, ''),
(22, 9, '2020-10-14 16:23:08', 'Laptop', 1, 'unit', '2020-10-15', 'Laptop untuk sales, spec standar', -1, 0, 0, NULL, NULL, '', '', NULL, 0, 0, 'masih ada'),
(23, 4, '2020-10-15 08:12:18', 'Mouse Logitech', 4, 'unit', '2020-10-21', 'Mouse wireless', 1, 1, 0, 5, 'PO/999', '200000', 'IDR', '2020-10-16', 0, 0, ''),
(24, 4, '2020-10-15 14:13:06', 'Lignin type A', 200, 'kg', '2020-10-24', 'stock lab', 1, 1, 0, 1, 'PO/999', '15000', 'IDR', '2020-10-16', 0, 0, ''),
(25, 4, '2020-10-15 14:36:39', 'Talc', 20, 'ton', '2020-10-24', 'Talc murni', 1, 1, 0, 5, NULL, '', '', NULL, 0, 0, ''),
(26, 5, '2020-10-15 14:41:51', 'Solar', 1000, 'liter', '2020-10-26', '', 1, 1, 0, 5, NULL, '', '', NULL, 0, 0, ''),
(27, 5, '2020-10-15 14:43:11', 'NaOH', 100, 'liter', '2020-10-24', 'Kualitas terbaik', -1, 0, 0, NULL, NULL, '', '', NULL, 0, 0, 'masih ada stok di gudang'),
(28, 5, '2020-10-15 14:43:47', 'Kertas A4', 4, 'rim', '2020-10-24', '70Gsm', 1, 1, 0, 5, NULL, '', '', NULL, 0, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `spp_history`
--

CREATE TABLE `spp_history` (
  `history_id` int(11) NOT NULL,
  `spp_id` int(11) NOT NULL,
  `status` varchar(30) NOT NULL,
  `content` text NOT NULL,
  `create_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `spp_history`
--

INSERT INTO `spp_history` (`history_id`, `spp_id`, `status`, `content`, `create_at`) VALUES
(47, 15, 'created', 'Dibuat oleh nanang', '2020-10-14 15:04:09'),
(48, 16, 'created', 'Dibuat oleh nanang', '2020-10-14 15:05:18'),
(49, 15, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-14 15:05:39'),
(50, 16, 'rejected', 'Sudah beli 5 pack sedang dikirim', '2020-10-14 15:06:13'),
(51, 15, 'process', 'Sudah disetujui manager purchasing', '2020-10-14 15:06:26'),
(52, 15, 'process', 'Sudah dibuat PO dengan nomor: LSC/2020/PO/02', '2020-10-14 15:37:57'),
(53, 17, 'created', 'Dibuat oleh farid', '2020-10-14 15:39:41'),
(54, 18, 'created', 'Dibuat oleh farid', '2020-10-14 15:40:31'),
(55, 19, 'created', 'Dibuat oleh agungkw', '2020-10-14 15:42:19'),
(56, 17, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-14 15:42:30'),
(57, 18, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-14 15:42:30'),
(58, 19, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-14 15:42:30'),
(59, 17, 'process', 'Sudah disetujui manager purchasing', '2020-10-14 15:43:02'),
(60, 19, 'process', 'Sudah disetujui manager purchasing', '2020-10-14 15:43:02'),
(61, 19, 'process', 'Sudah dibuat PO dengan nomor: LSC/2020/PO/03', '2020-10-14 15:45:34'),
(62, 17, 'process', 'Sudah dibuat PO dengan nomor: LSC/2020/PO/03', '2020-10-14 15:45:34'),
(63, 17, 'process', '', '2020-10-14 15:45:42'),
(64, 19, 'process', '', '2020-10-14 15:45:42'),
(65, 17, 'process', '', '2020-10-14 15:46:22'),
(66, 19, 'process', '2 buah lagi masih dalam pengerjaan', '2020-10-14 15:46:22'),
(67, 17, 'process', '', '2020-10-14 15:49:23'),
(68, 19, 'done', '2 buah lagi masih dalam pengerjaan', '2020-10-14 15:49:23'),
(69, 17, 'process', '', '2020-10-14 15:55:35'),
(70, 19, 'done', '', '2020-10-14 15:55:35'),
(71, 18, 'process', 'Sudah disetujui manager purchasing', '2020-10-14 15:58:43'),
(72, 18, 'canceled', 'Ga ada', '2020-10-14 15:59:02'),
(73, 20, 'created', 'Dibuat oleh agungkw', '2020-10-14 16:18:08'),
(74, 21, 'created', 'Dibuat oleh agungkw', '2020-10-14 16:21:02'),
(75, 20, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-14 16:21:21'),
(76, 21, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-14 16:21:21'),
(77, 20, 'process', 'Sudah disetujui manager purchasing', '2020-10-14 16:21:42'),
(78, 21, 'process', 'Sudah disetujui manager purchasing', '2020-10-14 16:21:42'),
(79, 22, 'created', 'Dibuat oleh farid', '2020-10-14 16:23:08'),
(80, 17, 'done', '', '2020-10-15 07:57:56'),
(81, 19, 'done', '', '2020-10-15 07:57:56'),
(82, 23, 'created', 'Dibuat oleh wildan', '2020-10-15 08:12:18'),
(83, 23, 'waiting', 'Menunggu persetujuan manager purchasing', '2020-10-15 08:12:33'),
(84, 23, 'process', 'Sudah disetujui manager purchasing', '2020-10-15 08:12:41'),
(85, 20, 'process', 'Sudah disetujui manager purchasing', '2020-10-15 11:38:43'),
(86, 20, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-10-15 11:39:50'),
(87, 15, 'process', 'coa sudah ada', '2020-10-15 13:50:51'),
(88, 24, 'created', 'Dibuat oleh wildan', '2020-10-15 14:13:06'),
(89, 20, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/20', '2020-10-15 14:20:34'),
(90, 20, 'process', '', '2020-10-15 14:22:22'),
(91, 20, 'done', '', '2020-10-15 14:22:52'),
(92, 15, 'process', 'coa sudah ada', '2020-10-15 14:22:59'),
(93, 22, 'rejected', 'SPP ditolak manager: masih ada', '2020-10-15 14:26:13'),
(94, 24, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-10-15 14:27:21'),
(95, 18, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Mansyur Ola', '2020-10-15 14:27:56'),
(96, 24, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Mansyur Ola', '2020-10-15 14:27:56'),
(97, 18, 'canceled', 'sudah tidak butuh', '2020-10-15 14:28:49'),
(98, 24, 'process', 'Sudah dibuat PO dengan nomor: PO/999', '2020-10-15 14:32:34'),
(99, 23, 'process', 'Sudah dibuat PO dengan nomor: PO/999', '2020-10-15 14:32:34'),
(100, 21, 'process', 'Sudah dibuat PO dengan nomor: PO/999', '2020-10-15 14:32:34'),
(101, 25, 'created', 'Dibuat oleh wildan', '2020-10-15 14:36:39'),
(102, 26, 'created', 'Dibuat oleh nanang', '2020-10-15 14:41:51'),
(103, 27, 'created', 'Dibuat oleh nanang', '2020-10-15 14:43:11'),
(104, 28, 'created', 'Dibuat oleh nanang', '2020-10-15 14:43:47'),
(105, 17, 'done', '', '2020-10-15 14:44:26'),
(106, 19, 'process', '', '2020-10-15 14:44:26'),
(107, 27, 'rejected', 'SPP ditolak manager: masih ada stok di gudang', '2020-10-15 14:56:23'),
(108, 26, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-10-15 14:56:32'),
(109, 25, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-10-15 15:04:53'),
(110, 28, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-10-15 15:04:53'),
(111, 25, 'process', 'Sudah disetujui manager purchasing, diproses oleh: M Aristu Prananca', '2020-10-15 15:05:03'),
(112, 26, 'process', 'Sudah disetujui manager purchasing, diproses oleh: M Aristu Prananca', '2020-10-15 15:05:03'),
(113, 28, 'process', 'Sudah disetujui manager purchasing, diproses oleh: M Aristu Prananca', '2020-10-15 15:05:03');

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
  `is_manager` int(11) NOT NULL DEFAULT '0',
  `is_purchasing` int(11) NOT NULL DEFAULT '0',
  `is_purch_manager` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `dept`, `username`, `password`, `manager_id`, `is_manager`, `is_purchasing`, `is_purch_manager`) VALUES
(1, 'Mansyur Ola', 'Accounting', 'mansyur', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 1, 1, 1),
(2, 'Ahmad Darmawansyah', 'Accounting', 'wawan', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 0, 0, 0),
(3, 'Abdel Haq Firdausy', 'manager', 'abdelhaq', '5f4dcc3b5aa765d61d8327deb882cf99', 3, 1, 0, 0),
(4, 'Wildan Abror Firdausy', 'Purchasing', 'wildan', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 0, 1, 0),
(5, 'M Aristu Prananca', 'Purchasing', 'nanang', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 0, 1, 0),
(6, 'Ferry Novriandi', 'rnd', 'ferry', '5f4dcc3b5aa765d61d8327deb882cf99', 6, 1, 0, 0),
(7, 'Subari', 'rnd', 'subari', '5f4dcc3b5aa765d61d8327deb882cf99', 6, 0, 0, 0),
(8, 'Agung Kusuma', 'marketing', 'agungkw', '5f4dcc3b5aa765d61d8327deb882cf99', 8, 1, 0, 0),
(9, 'Faridul A', 'marketing', 'farid', '5f4dcc3b5aa765d61d8327deb882cf99', 8, 0, 0, 0);

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
  MODIFY `spp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `spp_history`
--
ALTER TABLE `spp_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
