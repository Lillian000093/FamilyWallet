-- Roles Table
CREATE TABLE Roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE
);

-- Sex Table
CREATE TABLE Sex (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE
);

-- Place Table
CREATE TABLE Place (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Persons Table
CREATE TABLE Persons (
    id SERIAL PRIMARY KEY,
    phone_num VARCHAR(20) NOT NULL UNIQUE,
    sex_id INT NOT NULL,
    FOREIGN KEY (sex_id) REFERENCES Sex(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Users Table
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    role_id INT NOT NULL,
    person_id INT NOT NULL UNIQUE,
    FOREIGN KEY (role_id) REFERENCES Roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (person_id) REFERENCES Persons(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tables Table
CREATE TABLE Tables (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    author_id INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table_Мember Table
CREATE TABLE Table_Member (
  id SERIAL PRIMARY KEY,
    table_id INT NOT NULL,
    member_id INT NOT NULL,
    FOREIGN KEY (table_id) REFERENCES Tables(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Records Table
CREATE TABLE Records (
  id SERIAL PRIMARY KEY,
    datas DATE NOT NULL,
    cash DECIMAL(10,2) NOT NULL,
    place_id INT NOT NULL,
    table_member_id INT NOT NULL,
    FOREIGN KEY (table_member_id) REFERENCES Table_Member(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert Roles
INSERT INTO Roles (name) VALUES
('Admin'),('User');

-- Insert Sex
INSERT INTO Sex (name) VALUES
('Man'),('Woman');

-- Insert Place
INSERT INTO Place (name) VALUES
('Продукты'),('Косметика'),('Одежда'),
('Техника'),('Развлечения'),('Обучение/Развитие'),
('Жильё'),('Мебель'),('Кафе/Ресторан'),
('Канцелярия/Книги'),('Здоровье'),('Подарки'),
('Подписки'),('Другое'), ('Работа');

-- Insert Persons
INSERT INTO Persons (phone_num, sex_id) VALUES
('+375298765451', 1),('+375335466213', 2), ('+375441532166', 2);

-- Insert Users
INSERT INTO Users (username, password, role_id, person_id) VALUES
('pupupu', 'pupupu', 1, (SELECT id FROM Persons WHERE phone_num = '+375335466213' LIMIT 1)), -- Role Admin
('pipi', 'pipi', 2, (SELECT id FROM Persons WHERE phone_num = '+375441532166' LIMIT 1)),
('mimimi', 'mimimi', 2, (SELECT id FROM Persons WHERE phone_num = '+375298765451' LIMIT 1));

-- Insert Tables
INSERT INTO Tables (title, author_id) VALUES
('Доходы', (SELECT id FROM Users WHERE username = 'pipi' LIMIT 1)), 
('Расходы', (SELECT id FROM Users WHERE username = 'pipi' LIMIT 1));

-- Insert Table_Member
INSERT INTO Table_Member (table_id, member_id) VALUES
((SELECT id FROM Tables WHERE title = 'Доходы' LIMIT 1), (SELECT author_id FROM Tables WHERE title = 'Доходы' LIMIT 1)), -- Author 'Доходы'
((SELECT id FROM Tables WHERE title = 'Расходы' LIMIT 1), (SELECT author_id FROM Tables WHERE title = 'Расходы' LIMIT 1)), -- Author 'Расходы'
((SELECT id FROM Tables WHERE title = 'Расходы' LIMIT 1), (SELECT id FROM Users WHERE username = 'mimimi' LIMIT 1)),
((SELECT id FROM Tables WHERE title = 'Расходы' LIMIT 1), (SELECT id FROM Users WHERE username = 'pupupu' LIMIT 1));


-- Insert Records
INSERT INTO Records (datas, cash, place_id, table_member_id) VALUES
('2025-05-01', 22.05, (SELECT id FROM Place WHERE name = 'Продукты' LIMIT 1),
(SELECT id FROM Table_Member WHERE 
table_id = (SELECT id FROM Tables WHERE title = 'Расходы' LIMIT 1) AND member_id = (SELECT id FROM Users WHERE username = 'mimimi' LIMIT 1) LIMIT 1)),
('2025-04-30', 13.50, (SELECT id FROM Place WHERE name = 'Косметика' LIMIT 1),
(SELECT id FROM Table_Member WHERE 
table_id = (SELECT id FROM Tables WHERE title = 'Расходы' LIMIT 1) AND member_id = (SELECT id FROM Users WHERE username = 'pupupu' LIMIT 1) LIMIT 1)),
('2025-05-14', 5.00, (SELECT id FROM Place WHERE name = 'Работа' LIMIT 1),
(SELECT id FROM Table_Member WHERE 
table_id = (SELECT id FROM Tables WHERE title = 'Доходы' LIMIT 1) AND member_id = (SELECT id FROM Users WHERE username = 'pipi' LIMIT 1) LIMIT 1));
