-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: bdpgaxg8twbeafrskuue-mysql.services.clever-cloud.com    Database: bdpgaxg8twbeafrskuue
-- ------------------------------------------------------
-- Server version	8.4.2-2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Baby, Child & Toys'),(2,'Bakery'),(3,'Dairy, Chilled & Eggs'),(4,'Drinks'),(5,'Food Cupboard'),(6,'Frozen'),(7,'Health & Wellness'),(8,'Housebrand'),(9,'Meat & Seafood'),(10,'Pet Supplies'),(11,'Snacks & Confectionery'),(12,'Lifestyle'),(13,'Beauty & Personal Care'),(14,'Beer, Wine & Spirits'),(15,'Fruits & Vegetables'),(16,'Household'),(17,'Rice, Noodles & Cooking Ingredients'),(18,'Electronics');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `item_quantity` int NOT NULL,
  `total_price_per_item` double NOT NULL,
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `product_id_idx` (`product_id`),
  CONSTRAINT `order_id` FOREIGN KEY (`order_id`) REFERENCES `order_sheet` (`order_id`) ON UPDATE RESTRICT,
  CONSTRAINT `product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,1,1,62),(1,2,1,58.5),(1,3,1,29.9),(2,1,1,62),(2,2,1,58.5),(3,2,1,58.5),(3,3,1,29.9),(4,1,2,124),(5,1,2,124),(5,2,1,58.5),(6,1,7,434),(7,1,2,124);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_sheet`
--

DROP TABLE IF EXISTS `order_sheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_sheet` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(200) NOT NULL,
  `total_bill` double NOT NULL,
  `date_time` datetime NOT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_sheet`
--

LOCK TABLES `order_sheet` WRITE;
/*!40000 ALTER TABLE `order_sheet` DISABLE KEYS */;
INSERT INTO `order_sheet` VALUES (1,'Xiao Wei',150.4,'2025-09-08 00:00:00'),(2,'Brian',120.5,'2025-04-15 00:00:00'),(3,'Skibidi',88.4,'2025-03-28 00:00:00'),(4,'bri',124,'2025-06-28 17:59:17'),(5,'Hello',182.5,'2025-06-28 18:10:36'),(6,'yipyip',434,'2025-07-17 16:54:40'),(7,'Guest',124,'2025-07-17 23:06:57');
/*!40000 ALTER TABLE `order_sheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(200) NOT NULL,
  `uom_id` int NOT NULL,
  `price_per_unit` double unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  `category_id` int NOT NULL,
  `subcategory_id` int DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `product_id_UNIQUE` (`product_id`),
  KEY `uom_id_idx` (`uom_id`),
  KEY `category_id_idx` (`category_id`),
  KEY `subcategory_id_idx` (`subcategory_id`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  CONSTRAINT `fk_product_subcategory` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategory` (`subcategory_id`),
  CONSTRAINT `fk_product_uom` FOREIGN KEY (`uom_id`) REFERENCES `unit_of_measurement` (`uom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=250 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Similac Infant Formula Stage 1',2,62,89,1,1),(2,'Friso Gold Infant Formula',7,58.5,119,1,1),(3,'Dumex Dugro Growing Up Milk Powder',7,29.9,110,1,2),(4,'Nestle NAN Optipro',2,45.8,125,1,2),(5,'Gerber Organic Baby Cereal',14,7.9,130,1,3),(6,'Heinz Pumpkin & Sweetcorn Jar',15,2.8,150,1,3),(7,'Pigeon Nursing Bottle 240ml',4,8.9,140,1,4),(8,'Philips Avent Breast Pump Set',5,99,110,1,4),(9,'Kodomo Baby Bath 750ml',3,7.5,115,1,5),(10,'Bepanthen Nappy Rash Cream 30g',6,6.8,102,1,5),(11,'Pureen Baby Laundry Detergent 1.5L',3,7.8,115,1,6),(12,'Kodomo Anti-Bacterial Laundry Soap',1,6.9,132,1,6),(13,'Fisher Price Teether Toy',4,9.9,160,1,7),(14,'VTech Musical Rattle Set',5,19.5,110,1,7),(15,'Merries Tape Diapers S82',8,27.9,105,1,8),(16,'Huggies Platinum Naturemade M64',1,24.5,125,1,8),(17,'IKEA SNIGLAR Baby Cot',4,129,100,1,9),(18,'Graco Travel Lite Playard',5,199,104,1,9),(19,'Carter\'s 5-Pack Bodysuits',1,28,115,1,10),(20,'Mothercare Newborn Cap',4,7.9,140,1,10),(21,'Gardenia Enriched White Bread 400g',10,2.7,120,2,11),(22,'Sunshine Wholemeal Bread 600g',10,3,110,2,11),(23,'Seng Choon Fresh Eggs 10s',11,3.15,150,3,12),(24,'Farmpride Omega Eggs 10s',11,3.9,100,3,12),(25,'Meiji Fresh Milk 1L',3,3.75,120,3,13),(26,'Marigold HL Milk 1L',9,3.45,132,3,13),(27,'Dutch Lady UHT Milk 1L',1,2.5,110,3,14),(28,'Magnolia UHT Milk 1L',1,2.6,120,3,14),(29,'Cowhead Cheddar Cheese Slices 12s',13,4.9,150,3,15),(30,'Emborg Shredded Mozzarella 200g',1,6.9,160,3,15),(31,'SCS Salted Butter 250g',12,6.4,125,3,16),(32,'Flora Margarine 500g',16,4.5,120,3,16),(33,'Bulla Thickened Cream 300ml',3,4.9,120,3,17),(34,'President UHT Whipping Cream 200ml',1,3.5,110,3,17),(35,'Meiji Bulgaria Yoghurt 400g',16,3.4,100,3,18),(36,'Marigold Low Fat Yoghurt 135g',16,1.4,120,3,18),(37,'Prima Deli Chicken Ham Slices 200g',13,4.8,120,3,19),(38,'Farmland Cheese Frankfurter 250g',1,4.9,140,3,19),(39,'CP Shrimp Wonton 200g',1,5.9,110,3,20),(40,'Bibigo Beef Bulgogi Mandu 350g',1,7.9,120,3,20),(41,'Marigold Peel Fresh Orange Juice 1L',1,3.1,130,3,21),(42,'Yeo\'s Soy Bean Milk 1L',1,2.4,120,3,21),(43,'Nescafe Gold Instant Coffee 100g',2,7.5,110,4,22),(44,'Kopi-O 3-in-1 Coffee Sachets 15s',1,5.9,120,4,22),(45,'Lipton Yellow Label Tea Bags 50s',2,5.8,100,4,23),(46,'TWG English Breakfast Tea 15s',2,14,120,4,23),(47,'Marigold Peel Fresh Apple Juice 1L',9,3.1,150,4,24),(48,'Florida\'s Natural Orange Juice 1.5L',9,6.2,120,4,24),(49,'Coca-Cola Can Drink 320ml',7,0.9,200,4,25),(50,'Sprite Can Drink 320ml',7,0.9,160,4,25),(51,'Marigold UHT Milk 1L',1,2.6,110,4,26),(52,'Cowhead UHT Full Cream Milk 1L',1,2.7,115,4,26),(53,'Ice Mountain Bottled Water 1.5L',3,1.05,120,4,27),(54,'Spritzer Bottled Water 1.5L',3,1.1,130,4,27),(55,'Schweppes Soda Water 325ml',7,1.35,125,4,28),(56,'F&N Tonic Water 325ml',7,1.25,150,4,28),(57,'Nestle Koko Krunch 330g',2,5.9,110,5,29),(58,'Quaker Instant Oatmeal 800g',2,5.95,120,5,29),(59,'Maggi Curry Cup Noodles 5s',1,3.3,150,5,30),(60,'Nissin Cup Noodles Seafood',1,1.6,120,5,30),(61,'Ayam Brand Baked Beans 425g',7,2.3,110,5,31),(62,'Campbell\'s Mushroom Soup 420g',7,2.95,140,5,31),(63,'Kaya Toast Spread 250g',15,3.6,110,5,32),(64,'Capilano Honey 340g',15,7.9,120,5,32),(65,'Haagen-Dazs Vanilla Ice Cream 473ml',2,13.5,110,6,33),(66,'Walls Paddle Pop Rainbow 6s',1,6.5,140,6,33),(67,'CP Mochi Ice Cream 210g',1,6.2,120,6,34),(68,'Udders Frozen Yogurt 475ml',16,12.9,110,6,34),(69,'CP Shrimp Wonton 200g',14,5.9,150,6,35),(70,'Figo Fish Ball 500g',8,4.3,120,6,35),(71,'FairPrice Frozen Chicken Mid Joint',8,6.8,110,6,36),(72,'Frozen Pork Belly Slice 400g',14,7.9,130,6,36),(73,'Pacific West Fish Fillets 360g',8,9.9,110,6,37),(74,'FairPrice Frozen Prawns 500g',14,10.5,120,6,37),(75,'Redoxon Vitamin C 1000mg 30s',2,17.9,120,7,38),(76,'Blackmores Multivitamins 60s',2,32,100,7,38),(77,'Tiger Balm White Ointment 19g',6,4.5,110,7,39),(78,'Salonpas Pain Relief Patch 12s',1,5.9,120,7,39),(79,'Scott\'s Emulsion Cod Liver Oil',3,10.5,100,7,40),(80,'ChildLife Liquid Calcium 474ml',3,31.9,115,7,40),(81,'Panadol Tablets 20s',2,5.2,150,7,41),(82,'Strepsils Lozenges 24s',1,7.4,120,7,41),(83,'Durex Extra Safe Condoms 12s',1,15.9,110,7,42),(84,'Okamoto Zero One Condoms 3s',1,7.9,105,7,42),(85,'Hansaplast Fabric Plaster 20s',1,3.9,130,7,43),(86,'Dettol Antiseptic Liquid 250ml',3,5.3,120,7,43),(87,'Omron Digital Thermometer',4,12.9,120,7,44),(88,'Omron Blood Pressure Monitor',4,99,105,7,44),(89,'Tena Adult Diapers L10',8,21.9,110,7,45),(90,'Ensure Gold Vanilla 850g',1,38,100,7,45),(91,'FairPrice Lager Beer 330ml',7,2.1,120,8,46),(92,'FairPrice Red Wine 750ml',3,18,100,8,46),(93,'FairPrice Baby Wipes 80s',1,3.2,140,8,47),(94,'FairPrice Baby Cotton Buds 200s',1,2.1,120,8,47),(95,'FairPrice Frozen Chicken Drumsticks 1kg',8,8.3,110,8,48),(96,'FairPrice Frozen Fish Fillet 500g',8,6.9,130,8,48),(97,'FairPrice Pasteurised Milk 1L',9,2.7,125,8,49),(98,'FairPrice Omega 3 Eggs 10s',11,3.4,110,8,49),(99,'FairPrice Frozen Mixed Vegetables 1kg',8,4.2,140,8,50),(100,'FairPrice Frozen Spring Roll 400g',1,3.8,120,8,50),(101,'FairPrice Thai Fragrant Rice 5kg',8,13.5,100,8,51),(102,'FairPrice Spaghetti 500g',1,1.8,150,8,51),(103,'FairPrice Drinking Water 1.5L',3,0.9,200,8,52),(104,'FairPrice Green Tea 1.5L',3,1.8,110,8,52),(105,'FairPrice Detergent Powder 2.3kg',1,6.5,140,8,53),(106,'FairPrice Bathroom Tissue 10s',1,6.9,150,8,53),(107,'FairPrice LED Bulb',4,3.2,130,8,54),(108,'FairPrice Extension Cord 3m',4,8.9,100,8,54),(109,'Fresh Chicken Whole Leg',4,6,120,9,55),(110,'Fresh Chicken Breast',4,5.5,130,9,55),(111,'Fresh Pork Belly',4,9.5,110,9,56),(112,'Minced Pork',1,7,100,9,56),(113,'Australian Beef Striploin 200g',4,13.9,115,9,57),(114,'New Zealand Lamb Shoulder 300g',4,16.5,120,9,57),(115,'Fresh Batang Fish Steak',4,11.8,140,9,58),(116,'Prawns (Ang Kar) 500g',8,10,120,9,58),(117,'Chicken Meatballs 300g',1,5,140,9,59),(118,'Beef Meatballs 300g',1,5.2,120,9,59),(119,'Pedigree Adult Dry Dog Food 3kg',8,25.9,120,10,60),(120,'JerHigh Chicken Treats 70g',1,3.8,130,10,60),(121,'Whiskas Mackerel Cat Food 1.1kg',8,8.9,110,10,61),(122,'Sheba Tuna Fillet Cat Treat 4x12g',1,6.2,115,10,61),(123,'Vitakraft Rabbit Food 600g',1,8.9,140,10,62),(124,'Kaytee Clean & Cozy Bedding',8,14.5,120,10,62),(125,'Tetra Goldfish Food 100g',1,5.8,150,10,63),(126,'AquaOne Filter Cartridge',4,7,110,10,63),(127,'Ricola Swiss Herb Candy',1,2.5,120,11,64),(128,'Sugus Chewy Candy',1,1.8,140,11,64),(129,'Kit Kat 4 Fingers',1,1.9,160,11,65),(130,'Ferrero Rocher T3',2,4,120,11,65),(131,'Meiji Plain Crackers',1,2.7,130,11,66),(132,'Khong Guan Assorted Biscuits',2,6.2,110,11,66),(133,'Calbee Hot & Spicy Potato Chips',1,1.6,200,11,67),(134,'Twisties Cheeky Cheddar',1,1.3,150,11,67),(135,'Tong Garden Salted Almonds 140g',8,5.2,100,11,68),(136,'Nature\'s Wonders Dried Cranberries',8,4.8,110,11,68),(137,'Birthday Balloon Set',5,7.9,120,12,69),(138,'Confetti Pack',1,2.8,110,12,69),(139,'Disposable Paper Plates 20s',1,4.5,120,12,70),(140,'Plastic Forks 25s',1,2.2,140,12,70),(141,'Air Freshener',3,3.9,100,12,71),(142,'Car Microfiber Towel',4,5.5,110,12,71),(143,'Picnic Mat',8,12,120,12,72),(144,'Insulated Water Bottle',3,15,100,12,72),(145,'Unisex Cotton Socks 3 pairs',1,6.5,120,12,73),(146,'Foldable Umbrella',4,9.9,110,12,73),(147,'Rubik\'s Cube',4,7,120,12,74),(148,'UNO Card Game',2,9.8,130,12,74),(149,'Sudoku Puzzle Book',2,8.9,110,12,75),(150,'Children\'s Storybook',2,6,120,12,75),(151,'Energizer AA Batteries 4s',1,5.8,120,12,76),(152,'Panasonic AAA Batteries 2s',1,3.2,140,12,76),(153,'Pilot G2 Gel Pen',4,2.3,200,12,77),(154,'A4 Exercise Book',1,1.5,120,12,77),(155,'Flower Seeds Pack',1,2.8,150,12,78),(156,'Mini Watering Can',4,6,110,12,78),(157,'Pantene Shampoo 900ml',3,10.9,120,13,79),(158,'L\'Oreal Conditioner 330ml',3,8.5,140,13,79),(159,'Dettol Shower Gel 950ml',3,9.9,120,13,80),(160,'Lux Body Wash 900g',1,7.5,110,13,80),(161,'Biore Micellar Cleansing Water 300ml',3,10.9,120,13,81),(162,'Senka Perfect Whip 120g',6,7.8,130,13,81),(163,'Colgate Total Toothpaste 150g',6,5.5,140,13,82),(164,'Oral-B Toothbrush 3s',1,8.8,120,13,82),(165,'Vaseline Hand Cream 75ml',6,6.8,110,13,83),(166,'Scholl Cracked Heel Balm 60ml',6,12.5,100,13,83),(167,'Laurier Super Slimguard Pads 20s',1,5.3,120,13,84),(168,'Kotex Overnight Wing 28cm 18s',1,7.5,110,13,84),(169,'Veet Hair Removal Cream 100g',6,8.2,120,13,85),(170,'Gillette Venus Razor',4,9.8,100,13,85),(171,'Maybelline Color Show Nail Polish',3,5.9,120,13,86),(172,'Revlon Nail Clipper',4,3.5,140,13,86),(173,'Maybelline SuperStay Foundation',3,19.9,120,13,87),(174,'Silkygirl Matte Lipstick',3,8.9,130,13,87),(175,'Panasonic Facial Steamer',4,89,100,13,88),(176,'Philips Hair Dryer',4,39,110,13,88),(177,'Heineken Can Beer 320ml',7,3.2,200,14,89),(178,'Tiger Crystal Bottle 330ml',3,3.5,120,14,89),(179,'Jacob\'s Creek Shiraz 750ml',3,28.9,120,14,90),(180,'Wolf Blass Yellow Label Chardonnay',3,29.9,110,14,90),(181,'Moet & Chandon Imperial 750ml',3,85,100,14,91),(182,'Chandon Brut Sparkling Wine 750ml',3,49,110,14,91),(183,'Johnnie Walker Black Label 700ml',3,68,120,14,92),(184,'Smirnoff Red Vodka 700ml',3,49,110,14,92),(185,'Bundaberg Ginger Beer 375ml',7,2.8,140,14,93),(186,'Fever-Tree Tonic Water 200ml',7,2.2,130,14,93),(187,'Stainless Steel Wine Stopper',4,8,100,14,94),(188,'Crystal Wine Glass Set of 2',5,19.9,120,14,94),(189,'Australian Fuji Apple 5s',1,4.9,140,15,95),(190,'Philippines Cavendish Banana 6s',1,3.5,120,15,95),(191,'Cameron Highland Tomatoes 500g',8,3.2,150,15,96),(192,'Japanese Cucumber 3s',1,2.7,130,15,96),(193,'Top Liquid Detergent 2.5L',3,9.9,130,16,97),(194,'Persil Powder Detergent 2.7kg',1,12.5,110,16,97),(195,'Dynamo Power Gel Detergent 2.4kg',3,10.9,140,16,98),(196,'Fab Powder Detergent 2.1kg',1,7.5,100,16,98),(197,'Mama Lemon Dishwashing Liquid 800ml',3,3.9,120,16,99),(198,'Joy Lemon Dishwashing Liquid 800ml',3,3.3,130,16,99),(199,'Dettol Antibacterial Surface Cleaner 500ml',3,6.9,110,16,100),(200,'Clorox Bleach 2L',3,5.3,150,16,100),(201,'Scotch-Brite Sponge 3s',1,3.2,120,16,101),(202,'Vileda Mop Set',5,29.9,100,16,101),(203,'Ambi Pur Air Freshener 300ml',3,6.9,120,16,102),(204,'Glade Scented Gel',16,3.9,140,16,102),(205,'Shieldtox Mosquito Spray 600ml',3,7.9,100,16,103),(206,'Ridsect Cockroach Bait 6s',1,7.3,120,16,103),(207,'Kleenex Facial Tissue 5x120s',1,6.8,130,16,104),(208,'Cutie Compact Toilet Roll 10s',1,5.5,150,16,104),(209,'Lock & Lock Food Container Set',5,24.9,100,16,105),(210,'Corelle Dinner Plate',4,7.8,140,16,105),(211,'Stainless Steel Forks 6s',5,7,120,16,106),(212,'Glass Cup Set 4s',5,8.9,130,16,106),(213,'Bake King All Purpose Flour 1kg',1,2.2,120,17,107),(214,'Blue Band Margarine 250g',16,3.5,100,17,107),(215,'SongHe Thai Fragrant Rice 5kg',8,13.9,150,17,108),(216,'Royal Umbrella Jasmine Rice 5kg',8,15.5,120,17,108),(217,'Koka Instant Noodles Chicken 5s',1,3.2,140,17,109),(218,'Nissin Ramen Noodles 5s',1,5.9,120,17,109),(219,'San Remo Spaghetti 500g',1,2.8,110,17,110),(220,'Barilla Penne Rigate 500g',1,3.6,120,17,110),(221,'CSR White Sugar 1kg',1,2,140,17,111),(222,'Equal Classic Sweetener 50s',1,5.4,120,17,111),(223,'Knife Cooking Oil 2L',3,8.9,150,17,112),(224,'Naturel Sunflower Oil 2L',3,9.5,130,17,112),(225,'Prima Taste Laksa Paste 80g',14,3.9,110,17,113),(226,'Lee Kum Kee Soy Sauce 500ml',3,3.2,120,17,113),(227,'Heinz Tomato Ketchup 500g',3,3,130,17,114),(228,'Maggi Chilli Sauce 340g',3,2.5,110,17,114),(229,'Knorr Chicken Stock Cubes 12s',1,2.2,140,17,115),(230,'Ajinomoto MSG 250g',1,1.9,120,17,115),(231,'Campbell\'s Cream of Chicken Soup 305g',7,2.3,120,17,116),(232,'Heinz Classic Tomato Soup 400g',7,2.5,130,17,116),(233,'Philips Steam Iron',4,49,120,18,117),(234,'Mistral Table Fan 16\"',4,39,100,18,117),(235,'Xiaomi Mi Smart Band 7',4,59,110,18,118),(236,'Sony Wireless Earbuds',5,139,100,18,118),(237,'Canon EOS M50 Mirrorless Camera',4,799,110,18,119),(238,'DJI Mini SE Drone',4,399,100,18,119),(239,'Logitech Wireless Mouse',4,19.9,130,18,120),(240,'HP DeskJet Printer',4,59,120,18,120),(241,'Samsung 43\" Smart TV',4,499,100,18,121),(242,'Sony PlayStation 5 Console',4,799,110,18,121),(243,'Philips Airfryer XL',4,299,105,18,122),(244,'Panasonic Rice Cooker 1.8L',4,89,120,18,122),(245,'Mayer Blender 1.5L',4,59,140,18,123),(246,'Tefal Electric Kettle 1.7L',4,39,120,18,123),(247,'Samsung Galaxy A54',4,588,100,18,124),(248,'Apple iPad 10.2\"',4,528,110,18,124);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategory`
--

DROP TABLE IF EXISTS `subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategory` (
  `subcategory_id` int NOT NULL AUTO_INCREMENT,
  `subcategory_name` varchar(100) NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`subcategory_id`),
  KEY `category_id_idx` (`category_id`),
  CONSTRAINT `category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategory`
--

LOCK TABLES `subcategory` WRITE;
/*!40000 ALTER TABLE `subcategory` DISABLE KEYS */;
INSERT INTO `subcategory` VALUES (1,'Infant Formula',1),(2,'Milk Powder',1),(3,'Baby & Toddler Food',1),(4,'Nursing & Feeding',1),(5,'Baby Toiletries & Health',1),(6,'Baby Laundry & Cleaning',1),(7,'Toys & Play',1),(8,'Diapers',1),(9,'Baby Furniture',1),(10,'Baby Clothing & Accessories',1),(11,'Breads',2),(12,'Eggs',3),(13,'Fresh Milk',3),(14,'Uht Milk',3),(15,'Cheese',3),(16,'Butter, Margarine & Spreads',3),(17,'Cream',3),(18,'Yoghurt',3),(19,'Delicatessen',3),(20,'Chilled Food',3),(21,'Chilled Beverages',3),(22,'Coffee',4),(23,'Tea',4),(24,'Juices',4),(25,'Beverages',4),(26,'Uht Milk',4),(27,'Water',4),(28,'Drink Mixers',4),(29,'Breakfast',5),(30,'Ready-To-Eat',5),(31,'Canned Food',5),(32,'Jams, Spreads & Honey',5),(33,'Ice Cream',6),(34,'Frozen Desserts',6),(35,'Frozen Food',6),(36,'Frozen Meat',6),(37,'Frozen Seafood',6),(38,'Vitamins & Supplements',7),(39,'Topical Medication',7),(40,'Children\'s Health & Supplements',7),(41,'Oral Medication',7),(42,'Sexual Health',7),(43,'First Aids',7),(44,'Health Monitors & Aids',7),(45,'Elder Care',7),(46,'Beer, Wine & Spirits',8),(47,'Baby, Child & Toys',8),(48,'Meat & Seafood',8),(49,'Dairy, Chilled & Eggs',8),(50,'Frozen',8),(51,'Rice, Noodles & Cooking Ingredients',8),(52,'Drinks',8),(53,'Household',8),(54,'Electrical & Lifestyle',8),(55,'Chicken',9),(56,'Pork',9),(57,'Beef & Lamb',9),(58,'Fish & Seafood',9),(59,'Meatballs',9),(60,'For Dogs',10),(61,'For Cats',10),(62,'For Small Pets',10),(63,'For Aquatic Animals',10),(64,'Sweets',11),(65,'Chocolates',11),(66,'Biscuits',11),(67,'Snacks',11),(68,'Dried Fruits & Nuts',11),(69,'Party Supplies',12),(70,'Partyware',12),(71,'Automotive',12),(72,'Outdoor',12),(73,'Fashion & Accessories',12),(74,'Games & Toys',12),(75,'Books',12),(76,'Batteries',12),(77,'Stationery',12),(78,'Gardening',12),(79,'Hair Care',13),(80,'Bath & Body',13),(81,'Facial Care',13),(82,'Oral Care',13),(83,'Hand & Foot Care',13),(84,'Feminine Care',13),(85,'Hair Removal',13),(86,'Nail Care',13),(87,'Makeup',13),(88,'Beauty Appliances',13),(89,'Beer',14),(90,'Wine',14),(91,'Champagne & Sparkling Wine',14),(92,'Spirits',14),(93,'Non Alcoholic',14),(94,'Drinking Accessories',14),(95,'Fruits',15),(96,'Vegetables',15),(97,'Laundry Care',16),(98,'Detergents',16),(99,'Dishwashing',16),(100,'Cleaning Products',16),(101,'Cleaning Tools',16),(102,'Fresheners',16),(103,'Pest Control',16),(104,'Paper & Tissue',16),(105,'Kitchen & Dining',16),(106,'Tableware',16),(107,'Baking Needs',17),(108,'Rice',17),(109,'Noodles',17),(110,'Pasta',17),(111,'Sugar & Sweeteners',17),(112,'Oil',17),(113,'Cooking Paste & Sauces',17),(114,'Condiments',17),(115,'Seasonings',17),(116,'Soups',17),(117,'Home Appliances',18),(118,'Smart Wearables & Audio Technology',18),(119,'Cameras & Drones',18),(120,'Computer & Home Office',18),(121,'Television & Gaming Entertainment',18),(122,'Cooking Appliances',18),(123,'Kitchen Appliances',18),(124,'Mobile Phones, Tablets & Accessories',18);
/*!40000 ALTER TABLE `subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_of_measurement`
--

DROP TABLE IF EXISTS `unit_of_measurement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_of_measurement` (
  `uom_id` int NOT NULL AUTO_INCREMENT,
  `uom_name` varchar(100) NOT NULL,
  PRIMARY KEY (`uom_id`),
  UNIQUE KEY `order_id_UNIQUE` (`uom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_of_measurement`
--

LOCK TABLES `unit_of_measurement` WRITE;
/*!40000 ALTER TABLE `unit_of_measurement` DISABLE KEYS */;
INSERT INTO `unit_of_measurement` VALUES (1,'Pack'),(2,'Box'),(3,'Bottle'),(4,'Piece'),(5,'Set'),(6,'Tube'),(7,'Can'),(8,'Bag'),(9,'Carton'),(10,'Loaf'),(11,'Tray'),(12,'Stick'),(13,'Slice'),(14,'Pouch'),(15,'Jar'),(16,'Tub');
/*!40000 ALTER TABLE `unit_of_measurement` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-21  0:03:41
