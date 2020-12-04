-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 04, 2020 at 05:14 AM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.3.6

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
  `create_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `po`
--

INSERT INTO `po` (`po_id`, `user_id`, `vendor`, `po_date`, `create_at`) VALUES
('LSC015-IM-20', 4, 'Silkroad', '2020-11-20', '2020-11-30 09:06:42'),
('LSC016-IM-20', 4, 'Lignotech Florida', '2020-11-26', '2020-11-30 09:05:27'),
('NON-PO/10', 4, 'Skmedica-Tokopedia', '2020-11-12', '2020-11-12 08:26:32'),
('NON-PO/14', 4, 'toko-alisha -Tokopedia', '2020-11-17', '2020-11-16 15:46:38'),
('NON-PO/15', 4, 'CV Total pharmacy pharm', '2020-11-16', '2020-11-16 15:45:45'),
('NON-PO/19', 4, 'toko abc', '2020-11-13', '2020-11-13 15:10:18'),
('NON-PO/27', 4, 'IPB mart-Tokopedia', '2020-11-18', '2020-11-18 10:58:34'),
('NON-PO/28', 4, 'ijoroyopanen-Tokopedia', '2020-11-19', '2020-11-18 10:58:03'),
('NON-PO/29', 4, 'FixPrint Store', '2020-11-19', '2020-11-19 11:53:03'),
('NON-PO/30', 4, 'Plast RSM-Tokopedia', '2020-11-19', '2020-11-19 11:52:34'),
('NON-PO/31', 4, 'Multi Kimia-Tokopedia', '2020-11-19', '2020-11-19 11:51:54'),
('NON-PO/32', 4, 'Pelangi Swalayan', '2020-11-23', '2020-11-24 09:34:58'),
('NON-PO/33', 4, 'Pelangi Swalayan', '2020-11-23', '2020-11-24 09:28:34'),
('NON-PO/34', 4, 'MFirman-Tokopedia', '2020-11-19', '2020-11-19 11:51:22'),
('NON-PO/35', 4, 'Kastil Drakula-Tokopedia', '2020-11-19', '2020-11-19 11:50:49'),
('NON-PO/36', 4, 'Pelangi Swalayan', '2020-11-23', '2020-11-24 09:34:23'),
('NON-PO/39', 4, 'Arya Kimia', '2020-11-23', '2020-11-24 09:27:41'),
('NON-PO/40', 4, 'Arya Kimia', '2020-11-23', '2020-11-24 09:27:12'),
('NON-PO/43', 4, 'toko aneka grosir bdg-Tokopedia', '2020-11-24', '2020-11-24 11:39:39'),
('NON-PO/44', 4, 'Yulia Palet', '2020-11-24', '2020-11-24 09:38:14'),
('NON-PO/47', 4, 'BANYUKU FILTER-Tokopedia', '2020-12-01', '2020-11-30 08:55:35'),
('NON-PO/59', 4, 'HANOnlineShop-Tokopedia', '2020-11-27', '2020-11-30 09:10:24'),
('NON-PO/67', 4, 'centralfurniture-Tokopedia', '2020-12-03', '2020-12-03 15:23:33'),
('NON-PO/8', 4, 'Indo phoenix & Tuton\'s Store - Tokopedia', '2020-11-11', '2020-11-11 10:39:35'),
('NON-PO/9', 4, 'Milkyku-Tokopedia', '2020-11-11', '2020-11-11 10:41:39'),
('OP/CM/20/XI/234', 4, 'PT. Estrong Nusantara Mandiri', '2020-11-16', '2020-11-18 12:02:22'),
('OP/CM/20/XI/235', 4, 'ARYA KIMIA', '2020-11-17', '2020-11-18 08:54:52'),
('OP/CM/20/XI/236', 4, 'PT. Artha Christa', '2020-11-19', '2020-11-19 11:55:14'),
('OP/CM/20/XI/238', 5, 'Diah Anugrah', '2020-11-23', '2020-11-23 13:29:05'),
('OP/CM/20/XI/239', 4, 'PT. Smart Lab Indonesia', '2020-11-23', '2020-11-24 11:27:29'),
('OP/CM/20/XI/240', 5, 'PT. Pelita Abadi Sentosa', '2020-11-24', '2020-11-24 11:03:45'),
('OP/CM/20/XI/241', 4, 'PT. Karyapurna Paramitra', '2020-11-25', '2020-11-30 09:09:14'),
('OP/CM/20/XI/244', 4, 'PT. Bisindo Kencana', '2020-11-26', '2020-11-30 08:58:39'),
('OP/CM/20/XI/245', 4, 'PT. Bisindo Kencana', '2020-11-26', '2020-11-30 08:59:33'),
('OP/CM/20/XI/246', 4, 'PT. Bisindo Kencana', '2020-11-26', '2020-11-30 09:00:34'),
('OP/CM/20/XI/247', 4, 'PT. Bisindo Kencana', '2021-11-26', '2020-11-30 09:02:55'),
('OP/CM/20/XI/248', 4, 'PT. Kirana Mitra Abadi', '2020-11-26', '2020-11-30 09:04:03'),
('OP/CM/20/XII/252', 4, 'PT. Karya Muda Indochem', '2020-12-01', '2020-12-01 15:09:05'),
('OP/CM/20/XII/253', 4, 'PT. Interchem Plasagro Jaya', '2020-12-01', '2020-12-01 16:09:09');

-- --------------------------------------------------------

--
-- Table structure for table `spp`
--

CREATE TABLE `spp` (
  `spp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'yang mengajukan spp',
  `create_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'tgl pembuatan',
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
  `price` double NOT NULL,
  `currency` varchar(32) NOT NULL,
  `est_arrival` date DEFAULT NULL,
  `coa` int(11) NOT NULL COMMENT 'apakah coa sudah diterima?',
  `is_received` int(11) NOT NULL COMMENT '0: no, 1: partial, 2: full',
  `note` text NOT NULL,
  `revision` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `spp`
--

INSERT INTO `spp` (`spp_id`, `user_id`, `create_at`, `item`, `qty`, `unit`, `deadline`, `description`, `manager_approve`, `purch_manager_approve`, `purch_manager_cancel`, `handle_by`, `po_id`, `price`, `currency`, `est_arrival`, `coa`, `is_received`, `note`, `revision`) VALUES
(8, 4, '2020-11-11 10:33:19', 'Kertas Lakmus', 2, 'kotak', '2020-11-16', '', 1, 1, 0, 4, 'NON-PO/8', 84000, 'IDR', '2020-11-13', 0, 2, 'sudah diterima mas ferry', ''),
(9, 4, '2020-11-11 10:35:14', 'Polybag 40 x 40 cm', 4, 'pack', '2020-11-16', 'Request pak irfan,\n1 pack 27 lembar', 1, 1, 0, 4, 'NON-PO/9', 133600, 'IDR', '2020-11-13', 0, 2, 'sudah diterima mas fery', ''),
(10, 4, '2020-11-11 10:36:10', 'Moisture & PH meter analog', 1, 'Unit', '2020-11-16', 'Request pak irfan', 1, 1, 0, 4, 'NON-PO/10', 933000, 'IDR', '2020-11-13', 0, 2, 'diterima pak irfan', ''),
(12, 13, '2020-11-12 09:59:01', 'Cetakan beton kubus', 4, 'pcs', '2020-11-19', '', 1, -1, 0, NULL, NULL, 0, '', NULL, 0, 0, 'hanya tes apllikasi spp', ''),
(13, 14, '2020-11-12 10:15:09', 'cetakan beam ( 15*15*60 )', 6, 'pcs', '2020-11-20', '', 1, 1, 0, 4, NULL, 0, '', NULL, 0, 0, '', ''),
(14, 6, '2020-11-12 11:34:10', 'Melting Point Apparatus', 1, 'pcs', '2020-11-16', 'reff: https://www.tokopedia.com/toko-alisha/melting-point-apparatus-350-derajat-celcius?whid=0', 1, 1, 0, 4, 'NON-PO/14', 2929000, 'IDR', '2020-11-23', 0, 2, 'sudah diterima mas fery', ''),
(15, 6, '2020-11-12 11:35:01', 'Pipa kapiler untuk melting point apparatus', 100, 'pcs', '2020-11-16', 'mengikuti minimal order nya saja', 1, 1, 0, 4, 'NON-PO/15', 140500, 'IDR', '2020-11-23', 0, 2, 'sudah diterima lab pusat\n', ''),
(18, 13, '2020-11-13 15:02:08', 'pensil', 3, 'pcs', '2020-11-16', 'segera', -1, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, 'contoh demo applikasi', ''),
(19, 13, '2020-11-13 15:06:36', 'pensil', 5, 'pcs', '2020-11-16', 'segera', 1, 1, 0, 4, 'NON-PO/19', 2000, 'IDR', '2020-11-16', 0, 2, 'demo applikasi:sudah diterima mas arif', ''),
(20, 15, '2020-11-16 07:59:09', 'pilox putih', 1, 'dus', '2020-11-17', 'yang belanja mainthenan', 1, -1, 0, NULL, NULL, 0, '', NULL, 0, 0, 'sesuai hasil meeting kemarin, jika pembelian oleh maintenance pakai spp kertas, tidak input ke applikasi', ''),
(21, 15, '2020-11-16 07:59:36', 'pilox biru', 1, 'dus', '2020-11-17', 'yang belanja mainthenan', 1, -1, 0, NULL, NULL, 0, '', NULL, 0, 0, 'sesuai hasil meeting kemarin, jika pembelian oleh maintenance pakai spp kertas, tidak input ke applikasi', ''),
(22, 15, '2020-11-16 08:00:06', 'tali rapiah', 1, 'ball', '2020-11-17', 'yang belanja mainthenan', 1, -1, 0, NULL, NULL, 0, '', NULL, 0, 0, 'sesuai hasil meeting kemarin, jika pembelian oleh maintenance pakai spp kertas, tidak input ke applikasi', ''),
(23, 15, '2020-11-17 09:35:05', 'DP C-501', 50, 'kg', '2020-11-18', '', 1, 1, 0, 4, 'OP/CM/20/XI/235', 22660, 'IDR', '2020-11-19', 1, 2, '17 nov 20 sore sudah dimintakan ke adesif untuk antar, tolong infokan jika barang sudah datang', ''),
(24, 15, '2020-11-17 10:24:33', 'calcium nitrat', 500, 'kg', '2020-11-23', '', 1, 1, 0, 4, 'OP/CM/20/XI/236', 6000000, 'IDR', '2020-11-19', 0, 2, 'sudah diterima gudang ligno', ''),
(25, 15, '2020-11-17 15:23:58', 'strong seal bmastic', 100, 'kg', '2020-11-18', '', 1, 1, 0, 4, 'OP/CM/20/XI/234', 1980000, 'IDR', '2020-11-18', 0, 2, 'Sudah diterima Gudang', ''),
(26, 15, '2020-11-17 15:24:23', 'strong seal primer', 5, 'ltr', '2020-11-18', '', 1, 1, 0, 4, 'OP/CM/20/XI/234', 115000, 'IDR', '2020-11-18', 0, 2, 'Sudah diterima Gudang', ''),
(27, 7, '2020-11-18 08:39:42', 'Bibit jagung', 1, 'pak', '2020-11-20', '1 pack isi minimal 250 benih ', 1, 1, 0, 4, 'NON-PO/27', 26500, 'IDR', '2020-11-19', 0, 2, 'diterima mas fery', ''),
(28, 7, '2020-11-18 08:40:59', 'Bibit Tomat', 1, 'Pack', '2020-11-19', 'kebutuhan minimal 200 bibit(benih)', 1, 1, 0, 4, 'NON-PO/28', 37200, 'IDR', '2020-11-19', 0, 2, 'Diterima mas fery', ''),
(29, 19, '2020-11-18 11:28:19', 'Chip Cartridge HP 119A', 1, 'pcs', '2020-11-19', 'beri keterangan untuk cartridge warna kuning\n\nhttps://www.tokopedia.com/fixprintstore/chip-toner-cartridge-printer-hp-119a-w2092a-w2093a-w2091a-w2090a-kuning ', 1, 1, 0, 4, 'NON-PO/29', 299000, 'IDR', '2020-11-23', 0, 2, '', ''),
(30, 10, '2020-11-19 10:20:57', 'Plastik Klip', 3, 'Pack', '2020-11-23', 'Ukuran 25 x 16 cm', 1, 1, 0, 4, 'NON-PO/30', 74713, 'IDR', '2020-11-23', 0, 2, 'sudah diterima lab pusat', ''),
(31, 10, '2020-11-19 10:22:02', 'Kertas pH Universal', 3, 'Pack', '2020-11-23', '', 1, 1, 0, 4, 'NON-PO/31', 386600, 'IDR', '2020-11-23', 0, 2, 'sudah diterima lab pusat', ''),
(32, 10, '2020-11-19 10:23:09', 'Ballpoint Lab', 2, 'Pack', '2020-11-23', '', 1, 1, 0, 4, 'NON-PO/32', 42000, 'IDR', '2020-11-25', 0, 2, 'DIterima mas fery', ''),
(33, 10, '2020-11-19 10:23:58', 'Gelas Aqua', 2, 'Pack', '2020-11-23', '', 1, 1, 0, 4, 'NON-PO/33', 17000, 'IDR', '2020-11-25', 0, 2, 'sudah diterima mas fery', ''),
(34, 10, '2020-11-19 10:25:35', 'Sarung Tangan Latek', 2, 'Pack', '2020-11-20', 'Sarung Tangan Latek untuk Laboratorium kimia merk Sensi', 1, 1, 0, 4, 'NON-PO/34', 315000, 'IDR', '2020-11-23', 0, 2, 'sudah diterima lab pusat', ''),
(35, 10, '2020-11-19 10:26:11', 'Pipet Tetes Plastik', 100, 'pcs', '2020-11-23', '', 1, 1, 0, 4, 'NON-PO/35', 29800, 'IDR', '2020-11-23', 0, 2, 'sudah diterima lab pusat', ''),
(36, 10, '2020-11-19 10:44:23', 'Sumpit Bambu', 3, 'pack', '2020-11-23', 'Untuk pengaduk Lem , epoksi dan pewarna ', 1, 1, 0, 4, 'NON-PO/36', 12000, 'IDR', '2020-11-25', 0, 2, 'diterima mas fery', ''),
(37, 11, '2020-11-20 16:03:01', 'sekop', 1, 'pcs', '2020-11-21', 'uji coba aplikasi', -1, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, 'uji coba aplikasi', ''),
(38, 6, '2020-11-21 15:58:55', '', 2, 'ltr', '2020-11-23', 'Dibutuhkan segera (stock produksi sudah berubah warna)', -1, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, 'salah input', ''),
(39, 6, '2020-11-21 15:59:27', 'Asam Phospat Pekat', 5, 'kg', '2020-11-23', 'Dibutuhkan segera stock tidak ada', 1, 1, 0, 4, 'NON-PO/39', 128000, 'IDR', '2020-11-25', 0, 2, 'sudah diterima mas fery', ''),
(40, 6, '2020-11-21 16:00:08', 'Asam Sulfate Pekat', 5, 'kg', '2020-11-23', 'Dibutuhkan segera, stock di produksi sudah berubah warna ', 1, 1, 0, 4, 'NON-PO/40', 43000, 'IDR', '2020-11-25', 0, 2, 'diterima mas fery', ''),
(41, 10, '2020-11-23 09:55:26', 'Asam Sulfat Pro Analis Grade ( H2SO4 PA)', 2, 'Liter', '2020-11-26', '', 1, 1, 0, 4, 'OP/CM/20/XI/239', 544500, 'IDR', '2020-11-25', 1, 2, 'qty 2.5 L (1 botol)', ''),
(42, 15, '2020-11-23 11:42:41', 'drum kaleng', 500, 'pcs', '2020-11-24', '', 1, 1, 0, 5, 'OP/CM/20/XI/238', 90000000, 'IDR', '2020-11-25', 0, 2, 'sudah diterima full tgl 30 Nov 2020', ''),
(43, 15, '2020-11-23 11:43:08', 'senter led jumbo', 2, 'pcs', '2020-11-24', '', 1, 1, 0, 4, 'NON-PO/43', 239000, 'IDR', '2020-11-27', 0, 2, 'Diterima mas hendra', ''),
(44, 15, '2020-11-23 11:43:46', 'palet', 125, 'pcs', '2020-11-24', '', 1, 1, 0, 4, 'NON-PO/44', 5625000, 'IDR', '2020-11-27', 0, 2, 'sudah ambil semua', ''),
(45, 15, '2020-11-23 13:29:53', 'sodium gluconate', 1000, 'kg', '2020-11-24', '', 1, 1, 0, 5, 'OP/CM/20/XI/240', 10500000, 'IDR', '2020-11-25', 0, 2, 'Info dari PT PAS dikrim tgl 25/11/20 siang', ''),
(46, 10, '2020-11-24 15:55:50', 'Zeolite (Teraktivasi)', 1, 'kg', '2020-11-30', '', 1, 1, 0, 4, 'NON-PO/47', 26500, 'IDR', '2020-11-30', 0, 2, 'Sudah diterima mas subari', ''),
(47, 10, '2020-11-24 15:56:59', 'Karbon ( Teraktivasi )', 1, 'kg', '2020-11-30', '', 1, 1, 0, 4, 'NON-PO/47', 29500, 'IDR', '2020-11-30', 0, 2, 'Sudah diterima mas subari', ''),
(48, 16, '2020-11-25 13:46:11', 'SLACK WAX DAO', 20000, 'KG', '2020-11-28', ' ', 0, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, '', ''),
(49, 16, '2020-11-25 13:48:56', 'SLACK WAX LMO', 60000, 'KG', '2020-11-28', '', 0, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, '', ''),
(50, 20, '2020-11-26 14:55:44', 'Domsyo Lignin DS10', 48000, 'kg', '2021-03-15', '', 1, 1, 0, 4, 'OP/CM/20/XI/244', 26496, 'USD', '2021-03-01', 0, 0, '', ''),
(51, 20, '2020-11-26 14:58:46', '', 0, '', '2021-04-12', '', -1, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, '', ''),
(52, 20, '2020-11-26 15:00:49', 'Domsyo Lignin DS10', 48000, 'kg', '2021-04-12', '', 1, 1, 0, 4, 'OP/CM/20/XI/245', 26496, 'USD', '2021-04-01', 0, 0, '', ''),
(53, 20, '2020-11-26 15:01:37', 'Domsyo Lignin DS10', 48000, 'kg', '2021-05-17', '', 1, 1, 0, 4, 'OP/CM/20/XI/246', 26496, 'USD', '2021-05-03', 0, 0, '', ''),
(54, 20, '2020-11-26 15:02:16', 'Domsyo Lignin DS10', 48000, 'kg', '2021-06-14', '', 1, 1, 0, 4, 'OP/CM/20/XI/247', 26496, 'USD', '2021-06-01', 0, 0, '', ''),
(55, 20, '2020-11-26 15:04:19', 'Slack Wax SPO', 1020, 'kg', '2020-12-03', 'by confirmation', 1, 1, 0, 4, 'OP/CM/20/XI/248', 10761000, 'IDR', '2020-12-01', 0, 0, '', ''),
(56, 20, '2020-11-26 15:05:39', 'Borresperse NA 890 P', 24000, 'kg', '2021-01-18', '', 1, 1, 0, 4, 'LSC016-IM-20', 9120, 'USD', NULL, 0, 0, 'Hold by borregard, harga sudah berubah dari 0.38 menjadi 0.45', ''),
(57, 20, '2020-11-26 15:08:32', 'ARE - 580 FX', 21000, 'kg', '2020-12-14', '', 1, 1, 0, 4, 'LSC015-IM-20', 15540, 'USD', '2020-12-07', 0, 0, 'Book no. KR02848642, ETA 7 Des 2020', ''),
(58, 20, '2020-11-26 15:10:36', 'Slack Wax SPO', 19000, 'kg', '2020-12-02', '', 1, 1, 0, 4, 'OP/CM/20/XI/241', 155800000, 'IDR', '2020-12-01', 0, 0, '', ''),
(59, 20, '2020-11-27 10:11:19', 'corong stainles 30 cm', 3, '', '2020-11-28', 'diameter atas 30 cm\ndiameter bawah kalau bisa 1,5 inci, kalau tdk ya seadanya.\ntebal bahan minimal 1 mm', 1, 1, 0, 4, 'NON-PO/59', 399000, 'IDR', '2020-11-27', 0, 2, 'Sudah diterima mas hendra', ''),
(60, 16, '2020-11-30 09:19:12', 'KAPUR TOHOR', 20000, 'KG', '2020-12-04', 'Stock dilapangan habis', 0, 0, 0, NULL, NULL, 0, '', NULL, 0, 0, '', ''),
(61, 15, '2020-12-01 10:46:03', 'TEXAPON N 70', 14100, 'KG', '2020-12-02', '', 1, 1, 0, 1, NULL, 0, '', NULL, 0, 0, '', ''),
(62, 15, '2020-12-01 10:46:28', 'DHYTON ', 20600, 'KG', '2020-12-02', '', 1, 1, 0, 1, NULL, 0, '', NULL, 0, 0, '', ''),
(63, 15, '2020-12-01 10:46:55', 'SODIUM SULFAT', 8500, 'KG', '2020-12-02', '', 1, 1, 0, 4, 'OP/CM/20/XII/253', 19550000, 'IDR', '2020-12-02', 0, 0, '', ''),
(64, 15, '2020-12-01 10:47:54', 'METANOL', 3000, 'KG', '2020-12-02', '', 1, 1, 0, 4, 'OP/CM/20/XII/252', 20625000, 'IDR', '2020-12-02', 0, 2, 'Sudah diterima gudang', ''),
(65, 15, '2020-12-01 10:52:25', 'calcium nitrat', 1000, 'KG', '2020-12-02', '', 1, 1, 0, 4, NULL, 0, '', NULL, 0, 0, '', ''),
(66, 15, '2020-12-01 10:55:29', 'D FOAM IND 001', 165, 'KG', '2020-12-02', '', 1, 1, 0, 1, NULL, 0, '', NULL, 0, 0, '', ''),
(67, 19, '2020-12-03 11:52:30', 'Meja 1/2 biro', 1, 'unit', '2020-12-08', 'Meja untuk personil baru IT, akan mulai kerja hari Selasa', 1, 1, 0, 4, 'NON-PO/67', 793200, 'IDR', '2020-12-07', 0, 0, 'Sudah dipesan estimasi datang senin', '');

-- --------------------------------------------------------

--
-- Table structure for table `spp_history`
--

CREATE TABLE `spp_history` (
  `history_id` int(11) NOT NULL,
  `spp_id` int(11) NOT NULL,
  `status` varchar(30) NOT NULL,
  `content` text NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `spp_history`
--

INSERT INTO `spp_history` (`history_id`, `spp_id`, `status`, `content`, `create_at`) VALUES
(40, 8, 'created', 'Dibuat oleh wildan', '2020-11-11 10:33:19'),
(41, 9, 'created', 'Dibuat oleh wildan', '2020-11-11 10:35:14'),
(42, 10, 'created', 'Dibuat oleh wildan', '2020-11-11 10:36:10'),
(43, 8, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-11 10:36:31'),
(44, 9, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-11 10:36:31'),
(45, 10, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-11 10:36:31'),
(46, 8, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-11 10:36:37'),
(47, 9, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-11 10:36:37'),
(48, 10, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-11 10:36:37'),
(49, 8, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/10', '2020-11-11 10:39:35'),
(50, 9, 'process', 'Sudah dibuat PO dengan nomor: undefined', '2020-11-11 10:40:48'),
(51, 9, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/9', '2020-11-11 10:41:39'),
(52, 10, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/10', '2020-11-12 08:26:32'),
(53, 9, 'done', 'sudah diterima mas fery', '2020-11-12 08:27:12'),
(60, 12, 'created', 'Dibuat oleh arif', '2020-11-12 09:59:01'),
(61, 12, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-12 10:00:19'),
(62, 13, 'created', 'Dibuat oleh roni', '2020-11-12 10:15:09'),
(63, 14, 'created', 'Dibuat oleh ferry', '2020-11-12 11:34:10'),
(64, 15, 'created', 'Dibuat oleh ferry', '2020-11-12 11:35:01'),
(66, 14, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-12 16:11:02'),
(67, 15, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-12 16:11:03'),
(69, 14, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-13 10:14:44'),
(70, 12, 'rejected', 'SPP ditolak manager purchasing: hanya tes apllikasi spp', '2020-11-13 10:25:25'),
(71, 8, 'done', 'sudah diterima mas ferry', '2020-11-13 10:31:24'),
(72, 15, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-13 11:14:10'),
(75, 10, 'done', 'diterima pak irfan', '2020-11-13 13:41:24'),
(78, 18, 'created', 'Dibuat oleh arif', '2020-11-13 15:02:08'),
(79, 18, 'rejected', 'SPP ditolak manager: contoh demo applikasi', '2020-11-13 15:04:54'),
(80, 19, 'created', 'Dibuat oleh arif', '2020-11-13 15:06:36'),
(81, 19, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-13 15:06:56'),
(82, 19, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-13 15:08:07'),
(83, 19, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/19', '2020-11-13 15:10:18'),
(84, 19, 'process', 'baru terima 3', '2020-11-13 15:11:07'),
(85, 19, 'done', 'demo applikasi:sudah diterima mas arif', '2020-11-13 15:12:29'),
(86, 20, 'created', 'Dibuat oleh opik', '2020-11-16 07:59:09'),
(87, 21, 'created', 'Dibuat oleh opik', '2020-11-16 07:59:36'),
(88, 22, 'created', 'Dibuat oleh opik', '2020-11-16 08:00:06'),
(89, 15, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/15', '2020-11-16 15:45:45'),
(90, 14, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/14', '2020-11-16 15:46:38'),
(91, 15, 'process', 'beli 2 jenis, 1 mm dan 2 mm', '2020-11-16 15:46:54'),
(92, 14, 'process', 'sudah pesan', '2020-11-16 16:00:25'),
(93, 15, 'process', 'beli 2 jenis, 1 mm dan 2 mm. Sudah pesan', '2020-11-16 16:00:35'),
(94, 23, 'created', 'Dibuat oleh opik', '2020-11-17 09:35:05'),
(95, 24, 'created', 'Dibuat oleh opik', '2020-11-17 10:24:33'),
(96, 25, 'created', 'Dibuat oleh opik', '2020-11-17 15:23:58'),
(97, 26, 'created', 'Dibuat oleh opik', '2020-11-17 15:24:23'),
(98, 20, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(99, 21, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(100, 22, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(101, 23, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(102, 24, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(103, 25, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(104, 26, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-17 15:25:16'),
(105, 20, 'rejected', 'SPP ditolak manager purchasing: sesuai hasil meeting kemarin, jika pembelian oleh maintenance pakai spp kertas, tidak input ke applikasi', '2020-11-17 15:26:43'),
(106, 21, 'rejected', 'SPP ditolak manager purchasing: sesuai hasil meeting kemarin, jika pembelian oleh maintenance pakai spp kertas, tidak input ke applikasi', '2020-11-17 15:26:43'),
(107, 22, 'rejected', 'SPP ditolak manager purchasing: sesuai hasil meeting kemarin, jika pembelian oleh maintenance pakai spp kertas, tidak input ke applikasi', '2020-11-17 15:26:43'),
(108, 23, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-18 08:39:01'),
(109, 27, 'created', 'Dibuat oleh subari', '2020-11-18 08:39:42'),
(110, 28, 'created', 'Dibuat oleh subari', '2020-11-18 08:40:59'),
(111, 27, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-18 08:42:26'),
(112, 28, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-18 08:42:26'),
(113, 23, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/235', '2020-11-18 08:54:53'),
(114, 15, 'process', 'beli 2 jenis, 1 mm dan 2 mm. Sudah pesan.\ndicancel oleh supplier, yg 2 mm kosong', '2020-11-18 08:57:14'),
(115, 15, 'process', 'beli 2 jenis, 1 mm dan 2 mm. Sudah pesan.\ndicancel oleh supplier, yg 2 mm kosong.\n18/11/20 sudah pesan ulang yg 1 mm saja', '2020-11-18 09:05:11'),
(116, 23, 'process', '17 nov 20 sore sudah dimintakan ke adesif untuk antar, tolong infokan jika barang sudah datang', '2020-11-18 09:06:46'),
(117, 14, 'process', 'sudah pesan, sedang dikirim', '2020-11-18 09:07:32'),
(118, 24, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-18 10:51:19'),
(119, 25, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-18 10:51:19'),
(120, 26, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-18 10:51:20'),
(121, 27, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-18 10:51:20'),
(122, 28, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-18 10:51:20'),
(123, 28, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/28', '2020-11-18 10:58:03'),
(124, 27, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/27', '2020-11-18 10:58:34'),
(125, 28, 'process', 'sudah dipesan, jadi pesan 2 pack, 1 pack isi 200biji', '2020-11-18 10:59:14'),
(126, 27, 'process', 'Sudah dipesan 1 pack isi 250 biji', '2020-11-18 10:59:28'),
(127, 29, 'created', 'Dibuat oleh abdelhaq', '2020-11-18 11:28:19'),
(128, 29, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-18 11:28:28'),
(130, 26, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/234', '2020-11-18 12:02:22'),
(131, 25, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/234', '2020-11-18 12:02:22'),
(132, 14, 'done', 'sudah diterima mas fery', '2020-11-19 08:26:07'),
(133, 23, 'done', '17 nov 20 sore sudah dimintakan ke adesif untuk antar, tolong infokan jika barang sudah datang', '2020-11-19 08:27:46'),
(134, 30, 'created', 'Dibuat oleh agus', '2020-11-19 10:20:57'),
(135, 31, 'created', 'Dibuat oleh agus', '2020-11-19 10:22:03'),
(136, 32, 'created', 'Dibuat oleh agus', '2020-11-19 10:23:09'),
(137, 33, 'created', 'Dibuat oleh agus', '2020-11-19 10:23:58'),
(138, 34, 'created', 'Dibuat oleh agus', '2020-11-19 10:25:35'),
(139, 35, 'created', 'Dibuat oleh agus', '2020-11-19 10:26:11'),
(140, 30, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-19 10:31:20'),
(141, 31, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-19 10:31:31'),
(142, 32, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-19 10:31:44'),
(143, 33, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-19 10:31:53'),
(144, 34, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-19 10:32:06'),
(145, 35, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-19 10:32:12'),
(146, 29, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:35'),
(147, 30, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:36'),
(148, 31, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:36'),
(149, 32, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:36'),
(150, 33, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:36'),
(151, 34, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:36'),
(152, 35, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-19 10:33:36'),
(153, 36, 'created', 'Dibuat oleh agus', '2020-11-19 10:44:23'),
(154, 35, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/35', '2020-11-19 11:50:49'),
(155, 34, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/34', '2020-11-19 11:51:22'),
(156, 31, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/31', '2020-11-19 11:51:54'),
(157, 30, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/30', '2020-11-19 11:52:34'),
(158, 29, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/29', '2020-11-19 11:53:03'),
(159, 24, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/236', '2020-11-19 11:55:14'),
(160, 25, 'done', 'Sudah diterima Gudang', '2020-11-19 13:25:25'),
(161, 26, 'done', 'Sudah diterima Gudang', '2020-11-19 13:25:25'),
(162, 27, 'done', 'diterima mas fery', '2020-11-19 14:19:38'),
(163, 28, 'done', 'Diterima mas fery', '2020-11-19 14:19:47'),
(164, 24, 'process', 'Sedang diambil mbah ke marunda', '2020-11-19 14:20:17'),
(165, 15, 'process', 'beli 2 jenis, 1 mm dan 2 mm. Sudah pesan.\ndicancel oleh supplier, yg 2 mm kosong.\n18/11/20 sudah pesan ulang yg 1 mm saja', '2020-11-19 15:35:48'),
(166, 24, 'done', 'sudah diterima gudang ligno', '2020-11-20 08:10:34'),
(167, 37, 'created', 'Dibuat oleh eka', '2020-11-20 16:03:01'),
(168, 37, 'rejected', 'SPP ditolak manager: uji coba aplikasi', '2020-11-20 16:04:00'),
(169, 36, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-21 15:58:24'),
(170, 38, 'created', 'Dibuat oleh ferry', '2020-11-21 15:58:55'),
(171, 39, 'created', 'Dibuat oleh ferry', '2020-11-21 15:59:27'),
(172, 40, 'created', 'Dibuat oleh ferry', '2020-11-21 16:00:08'),
(173, 38, 'rejected', 'SPP ditolak manager: salah input', '2020-11-21 16:00:26'),
(174, 39, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-21 16:00:31'),
(175, 40, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-21 16:00:31'),
(176, 13, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-23 09:52:04'),
(177, 41, 'created', 'Dibuat oleh agus', '2020-11-23 09:55:26'),
(178, 13, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:38:24'),
(179, 36, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:38:42'),
(180, 39, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:39:33'),
(181, 40, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:39:33'),
(182, 41, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-23 11:41:27'),
(183, 42, 'created', 'Dibuat oleh opik', '2020-11-23 11:42:41'),
(184, 43, 'created', 'Dibuat oleh opik', '2020-11-23 11:43:08'),
(185, 44, 'created', 'Dibuat oleh opik', '2020-11-23 11:43:46'),
(186, 42, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-23 11:43:57'),
(187, 43, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-23 11:43:57'),
(188, 44, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-23 11:43:57'),
(189, 42, 'process', 'Sudah disetujui manager purchasing, diproses oleh: M Aristu Prananca', '2020-11-23 11:47:34'),
(190, 43, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:47:57'),
(191, 44, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:48:08'),
(192, 41, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-23 11:48:20'),
(193, 42, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/238', '2020-11-23 13:29:05'),
(194, 45, 'created', 'Dibuat oleh opik', '2020-11-23 13:29:53'),
(195, 45, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-23 13:30:03'),
(196, 40, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/40', '2020-11-24 09:27:12'),
(197, 39, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/39', '2020-11-24 09:27:41'),
(198, 33, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/33', '2020-11-24 09:28:35'),
(199, 40, 'done', 'diterima mas fery', '2020-11-24 09:32:15'),
(200, 15, 'done', 'sudah diterima lab pusat\n', '2020-11-24 09:32:41'),
(201, 30, 'done', 'sudah diterima lab pusat', '2020-11-24 09:32:58'),
(202, 31, 'done', 'sudah diterima lab pusat', '2020-11-24 09:33:08'),
(203, 33, 'done', 'sudah diterima mas fery', '2020-11-24 09:33:17'),
(204, 34, 'done', 'sudah diterima lab pusat', '2020-11-24 09:33:27'),
(205, 35, 'done', 'sudah diterima lab pusat', '2020-11-24 09:33:38'),
(206, 39, 'done', 'sudah diterima mas fery', '2020-11-24 09:33:48'),
(207, 36, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/36', '2020-11-24 09:34:23'),
(208, 32, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/32', '2020-11-24 09:34:58'),
(209, 44, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/44', '2020-11-24 09:38:14'),
(210, 32, 'done', 'DIterima mas fery', '2020-11-24 09:38:31'),
(211, 36, 'done', 'diterima mas fery', '2020-11-24 09:38:41'),
(212, 45, 'process', 'Sudah disetujui manager purchasing, diproses oleh: M Aristu Prananca', '2020-11-24 10:55:33'),
(213, 45, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/240', '2020-11-24 11:03:45'),
(214, 29, 'done', '', '2020-11-24 11:24:14'),
(215, 41, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/239', '2020-11-24 11:27:29'),
(216, 44, 'process', 'sudah pesan ambil jumat\n', '2020-11-24 11:27:44'),
(217, 41, 'process', 'qty 2.5 L (1 botol)', '2020-11-24 11:28:07'),
(218, 43, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/43', '2020-11-24 11:39:39'),
(219, 46, 'created', 'Dibuat oleh agus', '2020-11-24 15:55:50'),
(220, 47, 'created', 'Dibuat oleh agus', '2020-11-24 15:56:59'),
(221, 46, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-24 16:01:25'),
(222, 47, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-24 16:01:25'),
(223, 45, 'process', 'Info dari PT PAS dikrim tgl 25/11/20 siang', '2020-11-25 09:32:20'),
(224, 41, 'done', 'qty 2.5 L (1 botol)', '2020-11-25 10:44:23'),
(225, 43, 'process', 'sudah pesan, dalam perjalanan', '2020-11-25 11:13:39'),
(226, 48, 'created', 'Dibuat oleh agungtri', '2020-11-25 13:46:11'),
(227, 49, 'created', 'Dibuat oleh agungtri', '2020-11-25 13:48:56'),
(228, 50, 'created', 'Dibuat oleh ceo', '2020-11-26 14:55:44'),
(229, 50, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 14:56:21'),
(230, 51, 'created', 'Dibuat oleh ceo', '2020-11-26 14:58:46'),
(231, 51, 'rejected', 'SPP ditolak manager: ', '2020-11-26 14:59:37'),
(232, 52, 'created', 'Dibuat oleh ceo', '2020-11-26 15:00:49'),
(233, 53, 'created', 'Dibuat oleh ceo', '2020-11-26 15:01:37'),
(234, 54, 'created', 'Dibuat oleh ceo', '2020-11-26 15:02:16'),
(235, 52, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:02:43'),
(236, 53, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:02:43'),
(237, 54, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:02:43'),
(238, 55, 'created', 'Dibuat oleh ceo', '2020-11-26 15:04:19'),
(239, 56, 'created', 'Dibuat oleh ceo', '2020-11-26 15:05:39'),
(240, 55, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:06:03'),
(241, 56, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:06:03'),
(242, 57, 'created', 'Dibuat oleh ceo', '2020-11-26 15:08:32'),
(243, 58, 'created', 'Dibuat oleh ceo', '2020-11-26 15:10:36'),
(244, 57, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:10:46'),
(245, 58, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-26 15:10:47'),
(246, 45, 'done', 'Info dari PT PAS dikrim tgl 25/11/20 siang', '2020-11-26 15:23:58'),
(247, 43, 'done', 'Diterima mas hendra', '2020-11-26 15:41:48'),
(248, 59, 'created', 'Dibuat oleh ceo', '2020-11-27 10:11:19'),
(249, 59, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-11-27 10:11:33'),
(250, 46, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(251, 47, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(252, 50, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(253, 52, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(254, 53, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(255, 54, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(256, 55, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(257, 56, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:25'),
(258, 57, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:26'),
(259, 58, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:26'),
(260, 59, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-11-27 13:51:26'),
(261, 47, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/47', '2020-11-30 08:55:35'),
(262, 46, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/47', '2020-11-30 08:55:35'),
(263, 50, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/244', '2020-11-30 08:58:39'),
(264, 52, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/245', '2020-11-30 08:59:33'),
(265, 53, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/246', '2020-11-30 09:00:34'),
(266, 54, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/247', '2020-11-30 09:02:56'),
(267, 55, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/248', '2020-11-30 09:04:03'),
(268, 56, 'process', 'Sudah dibuat PO dengan nomor: LSC016-IM-20', '2020-11-30 09:05:27'),
(269, 57, 'process', 'Sudah dibuat PO dengan nomor: LSC015-IM-20', '2020-11-30 09:06:42'),
(270, 58, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XI/241', '2020-11-30 09:09:14'),
(271, 59, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/59', '2020-11-30 09:10:24'),
(272, 59, 'done', 'Sudah diterima mas hendra', '2020-11-30 09:11:04'),
(273, 46, 'done', 'Sudah diterima mas subari', '2020-11-30 09:12:45'),
(274, 47, 'done', 'Sudah diterima mas subari', '2020-11-30 09:12:45'),
(275, 56, 'process', 'Hold by borregard, harga sudah berubah dari 0.38 menjadi 0.45', '2020-11-30 09:13:26'),
(276, 57, 'process', 'Book no. KR02848642, ETA 7 Des 2020', '2020-11-30 09:14:52'),
(277, 60, 'created', 'Dibuat oleh agungtri', '2020-11-30 09:19:12'),
(278, 42, 'process', 'sudah datang 200, btb belum', '2020-11-30 09:44:04'),
(279, 44, 'process', 'sudah diambi40, 85 lg belum ambil\n', '2020-11-30 09:45:51'),
(280, 42, 'process', 'sudah datang 429, btb belum buat\n', '2020-11-30 14:55:38'),
(281, 42, 'process', 'sudah datang 429, SJ blm terima & btb belum dibuat\n', '2020-11-30 14:56:01'),
(282, 61, 'created', 'Dibuat oleh opik', '2020-12-01 10:46:03'),
(283, 62, 'created', 'Dibuat oleh opik', '2020-12-01 10:46:28'),
(284, 63, 'created', 'Dibuat oleh opik', '2020-12-01 10:46:56'),
(285, 64, 'created', 'Dibuat oleh opik', '2020-12-01 10:47:54'),
(286, 61, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-01 10:50:14'),
(287, 62, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-01 10:50:14'),
(288, 63, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-01 10:50:14'),
(289, 64, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-01 10:50:14'),
(290, 65, 'created', 'Dibuat oleh opik', '2020-12-01 10:52:25'),
(291, 65, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-01 10:52:31'),
(292, 66, 'created', 'Dibuat oleh opik', '2020-12-01 10:55:29'),
(293, 66, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-01 10:55:37'),
(294, 61, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Mansyur Ola', '2020-12-01 11:40:27'),
(295, 62, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Mansyur Ola', '2020-12-01 11:40:27'),
(296, 66, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Mansyur Ola', '2020-12-01 11:41:44'),
(297, 63, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-12-01 11:50:03'),
(298, 64, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-12-01 11:50:03'),
(299, 65, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-12-01 11:50:03'),
(300, 44, 'done', 'sudah ambil semua', '2020-12-01 11:55:16'),
(301, 64, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XII/252', '2020-12-01 15:09:05'),
(302, 63, 'process', 'Sudah dibuat PO dengan nomor: OP/CM/20/XII/253', '2020-12-01 16:09:09'),
(303, 67, 'created', 'Dibuat oleh abdelhaq', '2020-12-03 11:52:30'),
(304, 67, 'waiting', 'Disetujui manager, menunggu persetujuan manager purchasing', '2020-12-03 11:54:40'),
(305, 42, 'done', 'sudah diterima full tgl 30 Nov 2020', '2020-12-03 13:21:40'),
(306, 67, 'process', 'Sudah disetujui manager purchasing, diproses oleh: Wildan Abror Firdausy', '2020-12-03 14:06:20'),
(307, 67, 'process', 'Sudah dibuat PO dengan nomor: NON-PO/67', '2020-12-03 15:23:34'),
(308, 64, 'done', 'Sudah diterima gudang', '2020-12-03 16:38:15'),
(309, 67, 'process', 'Sudah dipesan estimasi datang senin', '2020-12-03 16:38:46');

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
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `dept`, `username`, `password`, `manager_id`, `is_manager`, `is_purchasing`, `is_purch_manager`) VALUES
(1, 'Mansyur Ola', 'Accounting', 'mansyur', '42272ec283e11fc4bf539c1dd02e7e30', 1, 1, 1, 1),
(2, 'Ahmad Darmawansyah', 'Accounting', 'wawan', '22f87640eeeb17e17e27bbdba30cea1d', 1, 0, 0, 0),
(4, 'Wildan Abror Firdausy', 'Purchasing', 'wildan', '521b7288bafe9f633f05f7cd38170b9d', 1, 0, 1, 0),
(5, 'M Aristu Prananca', 'Purchasing', 'nanang', '5b558ef03361a0c344b074759ce5de36', 1, 0, 1, 0),
(6, 'Ferry Novriandi', 'rnd', 'ferry', '1591327de6ec4265bfd68cf613e2ad60', 6, 1, 0, 0),
(7, 'Subari', 'rnd', 'subari', 'd33de07c4f7260689aefa2f0ba31d6a8', 6, 0, 0, 0),
(8, 'Agung Kusuma', 'marketing', 'agungkw', '17e924ac9bd7e7481ae07b22582472f1', 8, 1, 0, 0),
(9, 'Faridul A', 'marketing', 'farid', '078486d32a62f9180f7dd8b6bf259c4a', 8, 0, 0, 0),
(10, 'Agus Afrianto', 'rnd', 'agus', '84eaff3b72d37c2fa67f32db121e0221', 6, 0, 0, 0),
(11, 'Eka', 'technical', 'eka', '620ac6a5b7ee8e588312b19e07db655a', 11, 1, 0, 0),
(12, 'Amin Nasrulloh', 'technical', 'amin', '2c4e7d376f767c56fcd7d02cca339cfc', 11, 0, 0, 0),
(13, 'Arif', 'technical', 'arif', '58b385aa65409b65a281d2858cea09d2', 11, 0, 0, 0),
(14, 'Sahroni', 'technical', 'sahroni', '3ef29d1d5bc29c3ab01e85bd059d61b1', 11, 0, 0, 0),
(15, 'Abdul Rofik', 'produksi', 'opik', 'dfe2eaee9a63be5f922dcd067976874d', 15, 1, 0, 0),
(16, 'Agung Triyanto', 'produksi', 'agungtri', '93fd2e4336eba37c89428f30f7cc1499', 15, 0, 0, 0),
(17, 'Rahadian Faqih', 'Sales', 'faqih', '4993d46d7bfa9f72b315fabc24e4eed7', 1, 0, 0, 0),
(18, 'Oktia Hendra', 'HRD', 'oktia', '0981d83c0bad3939184bb4320253d58f', 18, 1, 0, 0),
(19, 'Abdel Haq Firdausy', 'IT', 'abdelhaq', 'c78a58f411def2586d0fa49480ded092', 19, 1, 0, 0),
(20, 'CEO', 'CEO', 'ceo', '1fdbc4a4012f96fdb7c3be7ee7ea2db2', 20, 1, 0, 0);

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
  MODIFY `spp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `spp_history`
--
ALTER TABLE `spp_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=310;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
