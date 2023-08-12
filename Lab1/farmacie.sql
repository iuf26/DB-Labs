CREATE DATABASE farmacie_database
use farmacie_database

CREATE TABLE farmacie (
farmacie_id INT PRIMARY KEY,
denumire VARCHAR(50) NOT NULL,
oras VARCHAR(50) NOT NULL)

CREATE TABLE farmacist (
farmacist_id INT PRIMARY KEY,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(50) NOT NULL,
farmacie_id INT FOREIGN KEY REFERENCES farmacie(farmacie_id))

CREATE TABLE manager (
manager_id INT FOREIGN KEY REFERENCES farmacie(farmacie_id),
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(50) NOT NULL,
CONSTRAINT pk_manager PRIMARY KEY(manager_id))

CREATE TABLE client (
client_id INT PRIMARY KEY,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(50) NOT NULL,
farmacie_id INT FOREIGN KEY REFERENCES farmacie(farmacie_id))

CREATE TABLE card_client (
card_client_id INT FOREIGN KEY REFERENCES client(client_id),
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(50) NOT NULL,
data_expirare DATE NOT NULL,
CONSTRAINT pk_card_client PRIMARY KEY(card_client_id))

CREATE TABLE reteta (
reteta_id INT PRIMARY KEY,
valoare INT NOT NULL,
numar_medicamente INT NOT NULL,
client_id INT FOREIGN KEY REFERENCES client(client_id))

CREATE TABLE producator (
producator_id INT PRIMARY KEY,
nume VARCHAR(50) NOT NULL,
sediu VARCHAR(50) NOT NULL,
numar_angajati INT NOT NULL)

CREATE TABLE medicament (
medicament_id INT PRIMARY KEY,
denumire VARCHAR(50) NOT NULL,
substanta VARCHAR(50) NOT NULL,
producator_id INT FOREIGN KEY REFERENCES producator(producator_id))

CREATE TABLE medicament_farmacie (
medicament_id INT FOREIGN KEY REFERENCES medicament(medicament_id),
farmacie_id INT FOREIGN KEY REFERENCES farmacie(farmacie_id),
CONSTRAINT pk_medicament_farmacie PRIMARY KEY (medicament_id,farmacie_id))

CREATE TABLE vanzare(
vanzare_id INT PRIMARY KEY,
suma INT NOT NULL,
data_vanzare DATE NOT NULL,
farmacie_id INT FOREIGN KEY REFERENCES farmacie(farmacie_id))