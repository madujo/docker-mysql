CREATE TABLE `STATION` (
  `STATION_CODE` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '역 코드',
  `STATION_NAME` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '역 이름',
  `SUBWAY_LINE` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '몇 호선인지',
  `PRIORITY` int DEFAULT '0' COMMENT '주요 역인지',
  `IS_BATCHABLE` int DEFAULT '0' COMMENT '배치 가능 유무',
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성 날짜',
  `UPDATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '최근 수정 날짜',
  PRIMARY KEY (`STATION_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;