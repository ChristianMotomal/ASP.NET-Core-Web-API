CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` varchar(150) NOT NULL,
    `ProductVersion` varchar(32) NOT NULL,
    PRIMARY KEY (`MigrationId`)
);

START TRANSACTION;
CREATE TABLE `AspNetRoles` (
    `Id` varchar(255) NOT NULL,
    `Name` varchar(256) NULL,
    `NormalizedName` varchar(256) NULL,
    `ConcurrencyStamp` longtext NULL,
    PRIMARY KEY (`Id`)
);

CREATE TABLE `AspNetUsers` (
    `Id` varchar(255) NOT NULL,
    `UserName` varchar(256) NULL,
    `NormalizedUserName` varchar(256) NULL,
    `Email` varchar(256) NULL,
    `NormalizedEmail` varchar(256) NULL,
    `EmailConfirmed` tinyint(1) NOT NULL,
    `PasswordHash` longtext NULL,
    `SecurityStamp` longtext NULL,
    `ConcurrencyStamp` longtext NULL,
    `PhoneNumber` longtext NULL,
    `PhoneNumberConfirmed` tinyint(1) NOT NULL,
    `TwoFactorEnabled` tinyint(1) NOT NULL,
    `LockoutEnd` datetime NULL,
    `LockoutEnabled` tinyint(1) NOT NULL,
    `AccessFailedCount` int NOT NULL,
    PRIMARY KEY (`Id`)
);

CREATE TABLE `Stocks` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Symbol` longtext NOT NULL,
    `CompanyName` longtext NOT NULL,
    `Purchase` decimal(18,2) NOT NULL,
    `LastDiv` decimal(18,2) NOT NULL,
    `Industry` longtext NOT NULL,
    `MarketCap` bigint NOT NULL,
    PRIMARY KEY (`Id`)
);

CREATE TABLE `AspNetRoleClaims` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `RoleId` varchar(255) NOT NULL,
    `ClaimType` longtext NULL,
    `ClaimValue` longtext NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_AspNetRoleClaims_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AspNetRoles` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserClaims` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `UserId` varchar(255) NOT NULL,
    `ClaimType` longtext NULL,
    `ClaimValue` longtext NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_AspNetUserClaims_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserLogins` (
    `LoginProvider` varchar(255) NOT NULL,
    `ProviderKey` varchar(255) NOT NULL,
    `ProviderDisplayName` longtext NULL,
    `UserId` varchar(255) NOT NULL,
    PRIMARY KEY (`LoginProvider`, `ProviderKey`),
    CONSTRAINT `FK_AspNetUserLogins_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserRoles` (
    `UserId` varchar(255) NOT NULL,
    `RoleId` varchar(255) NOT NULL,
    PRIMARY KEY (`UserId`, `RoleId`),
    CONSTRAINT `FK_AspNetUserRoles_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AspNetRoles` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_AspNetUserRoles_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserTokens` (
    `UserId` varchar(255) NOT NULL,
    `LoginProvider` varchar(255) NOT NULL,
    `Name` varchar(255) NOT NULL,
    `Value` longtext NULL,
    PRIMARY KEY (`UserId`, `LoginProvider`, `Name`),
    CONSTRAINT `FK_AspNetUserTokens_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Comments` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Title` longtext NOT NULL,
    `Content` longtext NOT NULL,
    `CreatedOn` datetime(6) NOT NULL,
    `StockId` int NULL,
    `AppUserId` varchar(255) NOT NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Comments_AspNetUsers_AppUserId` FOREIGN KEY (`AppUserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_Comments_Stocks_StockId` FOREIGN KEY (`StockId`) REFERENCES `Stocks` (`Id`)
);

CREATE TABLE `Portfolios` (
    `AppUserId` varchar(255) NOT NULL,
    `StockId` int NOT NULL,
    PRIMARY KEY (`AppUserId`, `StockId`),
    CONSTRAINT `FK_Portfolios_AspNetUsers_AppUserId` FOREIGN KEY (`AppUserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_Portfolios_Stocks_StockId` FOREIGN KEY (`StockId`) REFERENCES `Stocks` (`Id`) ON DELETE CASCADE
);

INSERT INTO `AspNetRoles` (`Id`, `ConcurrencyStamp`, `Name`, `NormalizedName`)
VALUES ('1d53ec19-7ca4-40ed-86e4-fb9137c6b707', '00e01e86-b99e-4ca6-b075-d7bbd77d3e95', 'User', 'USER');
SELECT ROW_COUNT();

INSERT INTO `AspNetRoles` (`Id`, `ConcurrencyStamp`, `Name`, `NormalizedName`)
VALUES ('378a8da1-8c66-4266-9fad-5db588c957e9', '01fa6a4b-12bf-46c0-a64e-c5b7e24fd869', 'Admin', 'ADMIN');
SELECT ROW_COUNT();


CREATE INDEX `IX_AspNetRoleClaims_RoleId` ON `AspNetRoleClaims` (`RoleId`);

CREATE UNIQUE INDEX `RoleNameIndex` ON `AspNetRoles` (`NormalizedName`);

CREATE INDEX `IX_AspNetUserClaims_UserId` ON `AspNetUserClaims` (`UserId`);

CREATE INDEX `IX_AspNetUserLogins_UserId` ON `AspNetUserLogins` (`UserId`);

CREATE INDEX `IX_AspNetUserRoles_RoleId` ON `AspNetUserRoles` (`RoleId`);

CREATE INDEX `EmailIndex` ON `AspNetUsers` (`NormalizedEmail`);

CREATE UNIQUE INDEX `UserNameIndex` ON `AspNetUsers` (`NormalizedUserName`);

CREATE INDEX `IX_Comments_AppUserId` ON `Comments` (`AppUserId`);

CREATE INDEX `IX_Comments_StockId` ON `Comments` (`StockId`);

CREATE INDEX `IX_Portfolios_StockId` ON `Portfolios` (`StockId`);

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
VALUES ('20261027075048_InitialCreateMySql', '10.0.13');

COMMIT;

