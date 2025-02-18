-- QUAN LY CHUYEN BAY

ALTER SESSION SET NLS_DATE_FORMAT =' DD/MM/YYYY HH24:MI:SS ';

--1. Tao user ten BAITHI gom co 4 table HANGHANGKHONG, CHUYENBAY, NHANVIEN,
--PHANCONG. Tao khoa chinh, khoa ngoai cho cac table do.
CREATE TABLE BTKHDL3.HANGHANGKHONG(
    MAHANG   VARCHAR2(2),
    TENHANG  NVARCHAR2(50),
    NGTL     DATE,
    DUONGBAY NUMBER,
    
    CONSTRAINT PK_HANGHANGKHONG PRIMARY KEY(MAHANG)
);

CREATE TABLE BTKHDL3.CHUYENBAY(
    MACB     VARCHAR2(5),
    MAHANG   VARCHAR2(2),
    XUATPHAT NVARCHAR2(50),
    DIEMDEN  NVARCHAR2(50),
    BATDAU   DATE,
    TGBAY    NUMBER,
    
    CONSTRAINT PK_CHUYENBAY PRIMARY KEY(MACB)
);

CREATE TABLE BTKHDL3.NHANVIEN(
    MANV      VARCHAR2(4),
    HOTEN     NVARCHAR2(50),
    GIOITINH  NVARCHAR2(10),
    NGSINH    DATE,
    NGVL      DATE,
    CHUYENMON NVARCHAR2(50),
    
    CONSTRAINT PK_NHANVIEN PRIMARY KEY(MANV)
);

CREATE TABLE BTKHDL3.PHANCONG(
    MACB    VARCHAR2(5),
    MANV    VARCHAR2(4),
    NHIEMVU NVARCHAR2(50),
    
    CONSTRAINT PK_PHANCONG PRIMARY KEY(MACB, MANV)
);

ALTER TABLE BTKHDL3.CHUYENBAY
ADD CONSTRAINT FK_CHUYENBAY_MAHANG FOREIGN KEY(MAHANG)
REFERENCES HANGHANGKHONG(MAHANG);

ALTER TABLE BTKHDL3.PHANCONG
ADD CONSTRAINT FK_PHANCONG_MACB FOREIGN KEY(MACB)
REFERENCES CHUYENBAY(MACB);

ALTER TABLE BTKHDL3.PHANCONG
ADD CONSTRAINT FK_PHANCONG_MANV FOREIGN KEY(MANV)
REFERENCES NHANVIEN(MANV);

--2. Nhap du lieu cho 4 table nhu de bai.
-- DISABLE KHOA NGOAI
ALTER TABLE BTKHDL3.CHUYENBAY DISABLE CONSTRAINT FK_CHUYENBAY_MAHANG;
ALTER TABLE BTKHDL3.PHANCONG  DISABLE CONSTRAINT FK_PHANCONG_MACB;
ALTER TABLE BTKHDL3.PHANCONG  DISABLE CONSTRAINT FK_PHANCONG_MANV;

-- Nhap du lieu HANGHANGKHONG
INSERT INTO BTKHDL3.HANGHANGKHONG
VALUES ('VN', 'Vietnam Airlines', '15/01/1956', 52);
INSERT INTO BTKHDL3.HANGHANGKHONG
VALUES ('VJ', 'Vietjet Air', '25/12/2011', 33);
INSERT INTO BTKHDL3.HANGHANGKHONG
VALUES ('BL', 'Jetstar Pacific Airlines', '01/12/1990', 13);

-- Nhap du lieu CHUYENBAY
INSERT INTO BTKHDL3.CHUYENBAY 
VALUES ('VN550', 'VN', 'TP.HCM', 'Singapore', '20/12/2015 13:15', 2);
INSERT INTO BTKHDL3.CHUYENBAY 
VALUES ('VJ331', 'VJ', 'Da Nang', 'Vinh', '28/12/2015 22:30', 1);
INSERT INTO BTKHDL3.CHUYENBAY 
VALUES ('BL696', 'BL', 'TP.HCM', 'Da Lat', '24/12/2015 06:00', 0.5);

-- Nhap du lieu NHANVIEN
INSERT INTO BTKHDL3.NHANVIEN
VALUES ('NV01', 'Lam Van Ben', 'Nam', '10/09/1978', '05/06/2000', 'Phi cong');
INSERT INTO BTKHDL3.NHANVIEN 
VALUES ('NV02', 'Duong Thi Luc', 'Nu', '22/03/1989', '12/11/2013', 'Tiep vien');
INSERT INTO BTKHDL3.NHANVIEN 
VALUES ('NV03', 'Hoang Thanh Tung', 'Nam', '29/07/1983', '11/04/2007', 'Tiep vien');

-- Nhap du lieu PHANCONG
INSERT INTO BTKHDL3.PHANCONG VALUES ('VN550', 'NV01', 'Co truong');
INSERT INTO BTKHDL3.PHANCONG VALUES ('VN550', 'NV02', 'Tiep vien');
INSERT INTO BTKHDL3.PHANCONG VALUES ('BL696', 'NV03', 'Tiep vien truong');

-- ENABLE KHOA NGOAI
ALTER TABLE BTKHDL3.CHUYENBAY ENABLE CONSTRAINT FK_CHUYENBAY_MAHANG;
ALTER TABLE BTKHDL3.PHANCONG  ENABLE CONSTRAINT FK_PHANCONG_MACB;
ALTER TABLE BTKHDL3.PHANCONG  ENABLE CONSTRAINT FK_PHANCONG_MANV;

SELECT * FROM BTKHDL3.HANGHANGKHONG;
SELECT * FROM BTKHDL3.CHUYENBAY;
SELECT * FROM BTKHDL3.NHANVIEN;
SELECT * FROM BTKHDL3.PHANCONG;

--3. Hien thuc rang buoc toan ven sau: Chuyen mon cua nhan vien chi duoc nhan 
--gia tri la ‘Phi cong’ hoac ‘Tiep vien’.
ALTER TABLE BTKHDL3.NHANVIEN
ADD CONSTRAINT CHECK_CHUYENMON CHECK(CHUYENMON = 'Phi cong' OR CHUYENMON = 'Tiep vien');

--4. Hien thuc rang buoc toan ven sau: Ngay bat dau chuyen bay luon lon hon ngay 
--thanh lap hang hang khong quan ly chuyen bay do.

--5. Tim tat ca cac nhan vien co sinh nhattrong thang 07.
SELECT *
FROM BTKHDL3.NHANVIEN
WHERE EXTRACT(MONTH FROM NGSINH) = 07;

--6. Tim chuyen bay co so nhan vien nhieu nhat.
SELECT MACB
FROM BTKHDL3.PHANCONG
GROUP BY MACB
HAVING COUNT(MANV) >= ALL(
                            SELECT COUNT(MANV)
                            FROM BTKHDL3.PHANCONG
                            GROUP BY MACB
                        );
                        
--7. Voi moi hang hang khong, thong ke so chuyen bay co diem xuat phat la ‘Da Nang’ 
--va co so nhan vien duoc phan cong it hon 2.
SELECT HHK.MAHANG, COUNT(DISTINCT PC.MACB) AS SOCHUYENBAY
FROM BTKHDL3.HANGHANGKHONG HHK 
    JOIN BTKHDL3.CHUYENBAY CB ON HHK.MAHANG = CB.MAHANG
    JOIN BTKHDL3.PHANCONG  PC ON CB.MACB = PC.MACB   
WHERE XUATPHAT = 'Da Nang'
    AND PC.MACB IN (
        SELECT PC1.MACB
        FROM BTKHDL3.HANGHANGKHONG HHK1 
            JOIN BTKHDL3.CHUYENBAY CB1 ON HHK1.MAHANG = CB1.MAHANG
            JOIN BTKHDL3.PHANCONG  PC1 ON CB1.MACB    = PC1.MACB   
        WHERE XUATPHAT = 'Da Nang'
        GROUP BY HHK1.MAHANG, PC1.MACB
        HAVING COUNT(MANV) <= 2
    )
GROUP BY HHK.MAHANG;

--8. Tim nhan vien duoc phan cong tham gia tat ca cac chuyen bay.
SELECT *
FROM BTKHDL3.NHANVIEN NHANVIEN
WHERE NOT EXISTS (
    SELECT *
    FROM BTKHDL3.CHUYENBAY CHUYENBAY
    WHERE NOT EXISTS (
        SELECT *
        FROM BTKHDL3.PHANCONG PHANCONG
        WHERE   PHANCONG.MACB = CHUYENBAY.MACB
            AND PHANCONG.MANV = NHANVIEN.MANV
    )
);