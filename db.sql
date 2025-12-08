-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: laravel_async
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_12_05_121330_create_products_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `stock` int NOT NULL,
  `rating` decimal(3,1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Vintage Set #1','Home & Garden',752.05,96,3.5,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(2,'Ultimate Gadget #2','Sports',969.77,62,3.1,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(3,'Professional Combo #3','Sports',667.40,82,4.5,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(4,'Modern Tool #4','Books',329.09,91,4.2,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(5,'Modern Bundle #5','Electronics',73.35,39,3.1,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(6,'Professional Combo #6','Books',602.62,93,3.9,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(7,'Modern Collection #7','Sports',84.27,44,3.5,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(8,'Deluxe System #8','Books',878.88,21,3.2,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(9,'Essential Pack #9','Home & Garden',185.60,38,4.3,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(10,'Deluxe Gadget #10','Home & Garden',327.69,7,3.9,'2025-12-05 12:27:00','2025-12-05 12:27:00'),(11,'Amazing Combo #11','Clothing',846.19,88,4.7,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(12,'Amazing Kit #12','Clothing',511.61,64,4.3,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(13,'Professional Combo #13','Books',70.80,61,4.2,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(14,'Amazing Device #14','Books',363.11,58,3.8,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(15,'Vintage Bundle #15','Home & Garden',189.68,14,4.1,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(16,'Modern Collection #16','Sports',263.24,46,4.2,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(17,'Vintage Bundle #17','Home & Garden',597.78,43,4.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(18,'Smart Bundle #18','Home & Garden',505.03,11,5.0,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(19,'Premium System #19','Sports',301.33,63,3.5,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(20,'Premium Kit #20','Electronics',812.84,73,4.9,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(21,'Ultimate Kit #21','Books',909.70,59,4.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(22,'Smart Gadget #22','Sports',334.64,64,3.2,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(23,'Amazing Bundle #23','Home & Garden',34.20,77,3.0,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(24,'Amazing Pack #24','Home & Garden',106.26,50,3.1,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(25,'Ultimate Device #25','Home & Garden',26.77,100,3.3,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(26,'Modern Kit #26','Books',25.07,32,3.4,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(27,'Vintage Collection #27','Home & Garden',820.74,92,3.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(28,'Classic Gadget #28','Books',55.46,29,3.5,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(29,'Essential System #29','Sports',908.96,39,4.1,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(30,'Modern Combo #30','Electronics',931.38,66,4.2,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(31,'Amazing Device #31','Books',995.64,93,4.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(32,'Vintage Kit #32','Electronics',815.09,86,3.3,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(33,'Amazing Collection #33','Clothing',328.98,28,4.0,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(34,'Classic System #34','Sports',306.11,87,4.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(35,'Professional System #35','Home & Garden',611.55,61,4.0,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(36,'Vintage Gadget #36','Electronics',981.15,47,4.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(37,'Amazing Gadget #37','Home & Garden',937.43,71,3.5,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(38,'Vintage Kit #38','Home & Garden',402.60,45,3.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(39,'Deluxe Gadget #39','Books',97.37,36,3.4,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(40,'Essential Kit #40','Clothing',861.85,8,3.8,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(41,'Premium Bundle #41','Books',707.47,21,4.2,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(42,'Smart Bundle #42','Books',850.97,34,4.2,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(43,'Classic Tool #43','Electronics',439.89,95,3.3,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(44,'Modern Device #44','Books',975.77,16,3.1,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(45,'Smart Device #45','Books',901.57,15,4.5,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(46,'Premium Gadget #46','Clothing',345.18,23,4.1,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(47,'Essential Combo #47','Books',821.97,90,3.6,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(48,'Premium System #48','Books',259.54,97,4.1,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(49,'Ultimate Gadget #49','Books',558.69,30,3.7,'2025-12-05 12:27:01','2025-12-05 12:27:01'),(50,'Modern System #50','Home & Garden',898.16,11,3.6,'2025-12-05 12:27:01','2025-12-05 12:27:01');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Test User','test@example.com','2025-12-05 12:27:01','$2y$12$BiUh0SUbnq.nS5Dy/BU5B.5.4lYEiIDDSahKQtWZssIvvfyhpo8FC','EkbTm3txy3','2025-12-05 12:27:01','2025-12-05 12:27:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-08  8:00:25
