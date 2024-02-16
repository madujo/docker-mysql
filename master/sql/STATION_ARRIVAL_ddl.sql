CREATE TABLE `STATION_ARRIVAL` (
  `STATION_CODE` varchar(6) NOT NULL COMMENT '역 코드',
  `ARRIVAL_YEAR` varchar(4) NOT NULL COMMENT '도착 년도',
  `ARRIVAL_MONTH` varchar(2) NOT NULL COMMENT '도착 월',
  `ARRIVAL_DAY` varchar(3) NOT NULL COMMENT '도착 요일',
  `ARRIVAL_TIME` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '도착 시간',
  `DELAY_TIME` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '-' COMMENT '지연 시간',
  `MESSAGE` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '-' COMMENT '특이사항',
  `CREATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성 날짜',
  `UPDATED_AT` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '최근 수정 날짜',
  PRIMARY KEY (`STATION_CODE`,`ARRIVAL_YEAR`,`ARRIVAL_MONTH`,`ARRIVAL_DAY`,`ARRIVAL_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;