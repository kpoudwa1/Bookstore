--https://www.amazon.com/books-used-books-textbooks/b/?ie=UTF8&node=283155&ref_=topnav_storetab_b
--Schemas
--bookstore - For storing information related to books
--users - For storing information related to users

--###############################################################
--								DDL
--###############################################################
--===============================================================
--								Book tables
--===============================================================

--Books
CREATE TABLE BOOKSTORE.BOOK (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(50),
    CATEGORY_ID INT REFERENCES BOOK_CATEGORY,
    IMAGE BLOB,
    SUMMARY VARCHAR(3000)
);

--Book_Format
CREATE TABLE BOOKSTORE.BOOK_FORMAT (
    ID INT REFERENCES BOOK,
    ISBN_10 VARCHAR(20),
    ISBN_13 VARCHAR(20),
    FORMAT VARCHAR(10) CHECK (FORMAT IN ('PAPERBACK' , 'HARDCOVER')),
    PRICE FLOAT(5 , 2 ),
    NUM_COPIES INT
);

--Book_Category
CREATE TABLE BOOKSTORE.BOOK_CATEGORY (
	ID INT PRIMARY KEY,
    CATEGORY_NAME VARCHAR(30) NOT NULL
);

--Author
CREATE TABLE BOOKSTORE.AUTHOR (
	ID INT PRIMARY KEY,
    AUTHOR_NAME VARCHAR(30) NOT NULL
);

--Book_Author
CREATE TABLE BOOKSTORE.BOOK_AUTHOR (
	BOOK_ID INT NOT NULL REFERENCES BOOK,
	AUTHOR_ID INT NOT NULL REFERENCES AUTHOR
);

--===============================================================
--								User tables
--===============================================================

--User
CREATE TABLE BOOKSTORE.USER (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
	DOB DATE,
	GENDER VARCHAR(1),
    EMAIL VARCHAR(50),
	PASSWORD VARCHAR(500),
	ADDRESS_LINE1 VARCHAR(50),
	ADDRESS_LINE2 VARCHAR(50),
	CITY VARCHAR(50),
	STATE VARCHAR(50),
	PINCODE VARCHAR(10)
);

--Order_Status
CREATE TABLE BOOKSTORE.ORDER_STATUS (
	ID INT PRIMARY KEY,
    STATUS_NAME VARCHAR(30) NOT NULL,
	DISPLAY_NAME VARCHAR(30) NOT NULL
);

--Purchases
CREATE TABLE BOOKSTORE.PURCHASES (
    ID INT AUTO_INCREMENT PRIMARY KEY,
	USER_ID INT REFERENCES USER,
	BOOK_ID INT REFERENCES BOOK,
	QUANTITY INT,
	ORDER_DATE DATE,
	STATUS INT REFERENCES ORDER_STATUS
);

--Track_Order
CREATE TABLE BOOKSTORE.TRACK_ORDER (
    ID INT AUTO_INCREMENT PRIMARY KEY,
	USER_ID INT REFERENCES USER,
	BOOK_ID INT REFERENCES BOOK,
	QUANTITY INT,
	STATUS INT REFERENCES ORDER_STATUS,
	STATUS_DATE DATE
);

Query for track order
SELECT BOOK_ID, B.IMAGE, O.DISPLAY_NAME, STATUS_DATE FROM
(SELECT BOOK_ID, MAX(STATUS) AS STATUS, STATUS_DATE FROM BOOKSTORE.TRACK_ORDER
 WHERE BOOK_ID IN
(SELECT DISTINCT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND BOOK_ID NOT IN
(SELECT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND STATUS = 5)) 
GROUP BY BOOK_ID
ORDER BY BOOK_ID ASC) AS T  INNER JOIN 
BOOKSTORE.BOOK B ON B.ID = T.BOOK_ID INNER JOIN BOOKSTORE.ORDER_STATUS O ON O.ID = T.STATUS;

SELECT T.BOOK_ID, B.IMAGE, O.DISPLAY_NAME, T.STATUS_DATE FROM BOOKSTORE.TRACK_ORDER T INNER JOIN 
BOOKSTORE.BOOK B ON B.ID = T.BOOK_ID INNER JOIN BOOKSTORE.ORDER_STATUS O ON O.ID = T.STATUS WHERE BOOK_ID IN
(SELECT DISTINCT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND BOOK_ID NOT IN
(SELECT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND STATUS = 5)) 
ORDER BY STATUS_DATE, STATUS ASC;

Old track order
SELECT * FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND BOOK_ID IN
(SELECT DISTINCT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND BOOK_ID NOT IN
(SELECT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = 20 AND STATUS = 5)) ORDER BY STATUS_DATE, STATUS ASC;

Books by category
SELECT * FROM BOOKSTORE.BOOK WHERE CATEGORY_ID = (SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Literature & Fiction') ORDER BY ID ASC;

--alert alert-success for success alert

Use set with while loop, loop till a set of desired size is not generated

--###############################################################
--Trigger
--###############################################################
CREATE DEFINER=`root`@`localhost` TRIGGER `PURCHASE_INSERT_OR_UPDATE` AFTER INSERT ON `track_order` FOR EACH ROW BEGIN
IF NEW.STATUS = 1 THEN
	INSERT INTO BOOKSTORE.PURCHASES (USER_ID, BOOK_ID, QUANTITY, ORDER_DATE, STATUS) VALUES (NEW.USER_ID, NEW.BOOK_ID, NEW.QUANTITY, NEW.STATUS_DATE, NEW.STATUS);
    UPDATE BOOKSTORE.BOOK_FORMAT SET NUM_COPIES = CASE
		WHEN NUM_COPIES = 0 THEN 0
		ELSE NUM_COPIES - NEW.QUANTITY
		END
	WHERE ID = NEW.BOOK_ID;
ELSEIF NEW.STATUS = 5 THEN 
	UPDATE BOOKSTORE.PURCHASES SET STATUS = NEW.STATUS WHERE USER_ID = NEW.USER_ID AND BOOK_ID = NEW.BOOK_ID;
END IF;    
END

--=============================
CREATE DEFINER=`root`@`localhost` TRIGGER `PURCHASE_INSERT_OR_UPDATE` AFTER INSERT ON `track_order` FOR EACH ROW BEGIN
IF NEW.STATUS = 1 THEN
	INSERT INTO BOOKSTORE.PURCHASES (USER_ID, BOOK_ID, QUANTITY, ORDER_DATE, STATUS) VALUES (NEW.USER_ID, NEW.BOOK_ID, NEW.QUANTITY, NEW.STATUS_DATE, NEW.STATUS);
ELSEIF NEW.STATUS = 5 THEN 
	UPDATE BOOKSTORE.PURCHASES SET STATUS = NEW.STATUS WHERE USER_ID = NEW.USER_ID AND BOOK_ID = NEW.BOOK_ID;
END IF;    
END

--=============================
CREATE OR REPLACE TRIGGER PURCHASE_INSERT_OR_UPDATE AFTER INSERT ON TRACK_ORDER FOR EACH ROW
BEGIN
IF NEW.STATUS = 1 THEN
INSERT INTO BOOKSTORE.PURCHASES (USER_ID, BOOK_ID, QUANTITY, ORDER_DATE, STATUS) VALUES (NEW.USER_ID, NEW.BOOK_ID, NEW.QUANTITY, NEW.STATUS_DATE, NEW.STATUS);
ELSIF NEW.STATUS = 5 THEN 
UPDATE BOOKSTORE.PURCHASES SET STATUS = NEW.STATUS WHERE USER_ID = OLD.USER_ID AND BOOK_ID = OLD.BOOK_ID;
END IF;
END

--=============================
CREATE TRIGGER PURCHASE_INSERT_OR_UPDATE AFTER INSERT ON BOOKSTORE.TRACK_ORDER FOR EACH ROW
BEGIN
IF NEW.STATUS = 1 THEN
INSERT INTO BOOKSTORE.PURCHASES (USER_ID, BOOK_ID, QUANTITY, ORDER_DATE, STATUS) VALUES (:NEW.USER_ID, :NEW.BOOK_ID, 1, :NEW.STATUS_DATE, :NEW.STATUS);
ELSEIF NEW.STATUS = 5 THEN 
UPDATE BOOKSTORE.PURCHASES SET STATUS = NEW.STATUS WHERE USER_ID = OLD.USER_ID AND BOOK_ID = OLD.BOOK_ID;
END IF;
END
--=============================
CREATE DEFINER = CURRENT_USER TRIGGER `bookstore`.`track_order_BEFORE_INSERT` BEFORE INSERT ON `track_order` FOR EACH ROW
BEGIN
IF NEW.STATUS = 1 THEN
	INSERT INTO BOOKSTORE.PURCHASES (USER_ID, BOOK_ID, QUANTITY, ORDER_DATE, STATUS) VALUES (NEW.USER_ID, NEW.BOOK_ID, 1, NEW.STATUS_DATE, NEW.STATUS);
ELSEIF NEW.STATUS = 5 THEN 
	UPDATE BOOKSTORE.PURCHASES SET STATUS = NEW.STATUS WHERE USER_ID = NEW.USER_ID AND BOOK_ID = NEW.BOOK_ID;
END IF;
END

DROP TRIGGER IF EXISTS `bookstore`.`track_order_BEFORE_INSERT`;
--=============================
CREATE DEFINER = CURRENT_USER TRIGGER `bookstore`.`track_order_BEFORE_INSERT` BEFORE INSERT ON `track_order` FOR EACH ROW
BEGIN
IF NEW.STATUS = 1 THEN
	INSERT INTO BOOKSTORE.PURCHASES (USER_ID, BOOK_ID, QUANTITY, ORDER_DATE, STATUS) VALUES (NEW.USER_ID, NEW.BOOK_ID, 1, NEW.STATUS_DATE, NEW.STATUS);
ELSEIF NEW.STATUS = 5 THEN 
	UPDATE BOOKSTORE.PURCHASES SET STATUS = NEW.STATUS WHERE USER_ID = NEW.USER_ID AND BOOK_ID = NEW.BOOK_ID;
END IF;
END



--###############################################################
--								DML
--###############################################################
--Book_Category
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (1, 'Arts & Photography');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (2, 'Biographies & Memoirs');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (3, 'Business & Investing');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (4, 'Children''s Books');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (5, 'Cookbooks, Food & Wine');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (6, 'History');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (7, 'Literature & Fiction');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (8, 'Mystery & Suspense');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (9, 'Romance');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (10, 'Sci-Fi & Fantasy');
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES (11, 'Teens & Young Adult');

--Author
INSERT INTO BOOKSTORE.AUTHOR VALUES (1, 'Amish Tripathi');
INSERT INTO BOOKSTORE.AUTHOR VALUES (2, 'Chris Gardner');
INSERT INTO BOOKSTORE.AUTHOR VALUES (3, 'Michelle Obama');
INSERT INTO BOOKSTORE.AUTHOR VALUES (4, 'Paulo Coelho');
INSERT INTO BOOKSTORE.AUTHOR VALUES (5, 'Robert T. Kiyosaki');
INSERT INTO BOOKSTORE.AUTHOR VALUES (6, 'Robin Sharma');
INSERT INTO BOOKSTORE.AUTHOR VALUES (7, 'Walter Isaacson');
INSERT INTO BOOKSTORE.AUTHOR VALUES (8, 'Zadie Smith');
INSERT INTO BOOKSTORE.AUTHOR VALUES (9, 'J. K. Rowling');
INSERT INTO BOOKSTORE.AUTHOR VALUES (10, 'Urvashi Pitre');
INSERT INTO BOOKSTORE.AUTHOR VALUES (11, 'Tadashi Ono');
INSERT INTO BOOKSTORE.AUTHOR VALUES (12, 'Harris Salat');
INSERT INTO BOOKSTORE.AUTHOR VALUES (13, 'Makiko Itoh');
INSERT INTO BOOKSTORE.AUTHOR VALUES (14, 'Enrique Olvera');
INSERT INTO BOOKSTORE.AUTHOR VALUES (15, 'Chrissy Teigen');
INSERT INTO BOOKSTORE.AUTHOR VALUES (16, 'Adeena Sussman');
INSERT INTO BOOKSTORE.AUTHOR VALUES (17, 'Saroo Brierley');
INSERT INTO BOOKSTORE.AUTHOR VALUES (18, 'David Gilmour');
INSERT INTO BOOKSTORE.AUTHOR VALUES (19, 'Susan Wise Bauer');
INSERT INTO BOOKSTORE.AUTHOR VALUES (20, 'Roberta Edwards');
INSERT INTO BOOKSTORE.AUTHOR VALUES (21, 'William Carlsen');
INSERT INTO BOOKSTORE.AUTHOR VALUES (22, 'Alex Michaelides');
INSERT INTO BOOKSTORE.AUTHOR VALUES (23, 'James Patterson');
INSERT INTO BOOKSTORE.AUTHOR VALUES (24, 'Maxine Paetro');
INSERT INTO BOOKSTORE.AUTHOR VALUES (25, 'Lisa Jewell');
INSERT INTO BOOKSTORE.AUTHOR VALUES (26, 'A. J Finn');
INSERT INTO BOOKSTORE.AUTHOR VALUES (27, 'Stephen King');
INSERT INTO BOOKSTORE.AUTHOR VALUES (28, 'Gail Honeyman');
INSERT INTO BOOKSTORE.AUTHOR VALUES (29, 'Anna Todd');
INSERT INTO BOOKSTORE.AUTHOR VALUES (30, 'Kevin Kwan');
INSERT INTO BOOKSTORE.AUTHOR VALUES (31, 'Tracey Garvis Graves');
INSERT INTO BOOKSTORE.AUTHOR VALUES (32, 'James S. A. Corey');
INSERT INTO BOOKSTORE.AUTHOR VALUES (33, 'Adrian Tchaikovsky');
INSERT INTO BOOKSTORE.AUTHOR VALUES (34, 'Carl Sagan');
INSERT INTO BOOKSTORE.AUTHOR VALUES (35, 'Stephenie Meyer');
INSERT INTO BOOKSTORE.AUTHOR VALUES (36, 'Erika Stalder');
INSERT INTO BOOKSTORE.AUTHOR VALUES (37, 'Steven Jenkins');
INSERT INTO BOOKSTORE.AUTHOR VALUES (38, 'Tanynika Pace');
INSERT INTO BOOKSTORE.AUTHOR VALUES (39, 'Megan Kaye');
INSERT INTO BOOKSTORE.AUTHOR VALUES (40, 'Hayley DiMarco');
INSERT INTO BOOKSTORE.AUTHOR VALUES (41, 'Sean Covey');






INSERT INTO BOOKSTORE.AUTHOR VALUES (42, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (43, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (44, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (45, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (46, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (47, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (48, '');
INSERT INTO BOOKSTORE.AUTHOR VALUES (49, '');


--Books
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Monk Who Sold His Ferrari',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Literature & Fiction'),'The book develops around two characters, Julian Mantle and his best friend John, in the form of conversation. Julian narrates his spiritual experiences during a Himalayan journey which he undertook after selling his holiday home and red Ferrari.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Alchemist',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Literature & Fiction'),'The story of the treasures Santiago finds along the way teaches us, as only a few stories can, about the essential wisdom of listening to our hearts, learning to read the omens strewn along life''s path, and, above all, following our dreams.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Immortals of Meluha',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Literature & Fiction'),'1900 BC. In what modern Indians mistakenly call the Indus Valley Civilisation. The inhabitants of that period called it the land of Meluha – a near perfect empire created many centuries earlier by Lord Ram, one of the greatest monarchs that ever lived. This once proud empire and its Suryavanshi rulers face severe perils as its primary river, the revered Saraswati, is slowly drying to extinction. They also face devastating terrorist attacks from the east, the land of the Chandravanshis. To make matters worse, the Chandravanshis appear to have allied with the Nagas, an ostracised and sinister race of deformed humans with astonishing martial skills. The only hope for the Suryavanshis is an ancient legend: ‘When evil reaches epic proportions, when all seems lost, when it appears that your enemies have triumphed, a hero will emerge.’ Is the rough-hewn Tibetan immigrant Shiva, really that hero? And does he want to be that hero at all? Drawn suddenly to his destiny, by duty as well as by love, will Shiva lead the Suryavanshi vengeance and destroy evil? This is the first book in a trilogy on Shiva, the simple man whose karma re-cast him as our Mahadev, the God of Gods.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Secret of the Nagas',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Literature & Fiction'),'Today, He is a God. 4000 years ago, He was just a man. The hunt is on. The sinister Naga warrior has killed his friend Brahaspati and now stalks his wife Sati. Shiva, the Tibetan immigrant who is the prophesied destroyer of evil, will not rest till he finds his demonic adversary. His vengeance and the path to evil will lead him to the door of the Nagas, the serpent people. Of that he is certain. The evidence of the malevolent rise of evil is everywhere. A kingdom is dying as it is held to ransom for a miracle drug. A crown prince is murdered. The Vasudevs Shiva''s philosopher guides betray his unquestioning faith as they take the aid of the dark side. Even the perfect empire, Meluha is riddled with a terrible secret in Maika, the city of births. Unknown to Shiva, a master puppeteer is playing a grand game. In a journey that will take him across the length and breadth of ancient India, Shiva searches for the truth in a land of deadly mysteries only to find that nothing is what it seems. Fierce battles will be fought. Surprising alliances will be forged. Unbelievable secrets will be revealed in this second book of the Shiva Trilogy, the sequel to the #1 national bestseller, The Immortals of Meluha.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Oath of the Vayuputras',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Literature & Fiction'),'Today, Shiva is a god. But four thousand years ago, he was just a man - until he brought his people to Meluha, a near-perfect empire founded by the great king Lord Ram. There he discovered he was the Neelkanth, a barbarian long prophesied to be Meluha''s saviour.
But in his hour of victory fighting the Chandravanshis - Meluha''s enemy - he discovered they had their own prophecy. 
Now he must fight to uncover the treachery within his inner circle, and unmask those who are about to destroy all that he has fought for. Shiva is about to learn that good and evil are two sides of the same coin...');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Steve Jobs',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Biographies & Memoirs'),'Based on more than forty interviews with Jobs conducted over two years—as well as interviews with more than a hundred family members, friends, adversaries, competitors, and colleagues—Walter Isaacson has written a riveting story of the roller-coaster life and searingly intense personality of a creative entrepreneur whose passion for perfection and ferocious drive revolutionized six industries: personal computers, animated movies, music, phones, tablet computing, and digital publishing.
At a time when America is seeking ways to sustain its innovative edge, and when societies around the world are trying to build digital-age economies, Jobs stands as the ultimate icon of inventiveness and applied imagination. He knew that the best way to create value in the twenty-first century was to connect creativity with technology. He built a company where leaps of the imagination were combined with remarkable feats of engineering.  
Although Jobs cooperated with this book, he asked for no control over what was written nor even the right to read it before it was published. He put nothing off-limits. He encouraged the people he knew to speak honestly. And Jobs speaks candidly, sometimes brutally so, about the people he worked with and competed against. His friends, foes, and colleagues provide an unvarnished view of the passions, perfectionism, obsessions, artistry, devilry, and compulsion for control that shaped his approach to business and the innovative products that resulted.
Driven by demons, Jobs could drive those around him to fury and despair. But his personality and products were interrelated, just as Apple’s hardware and software tended to be, as if part of an integrated system. His tale is instructive and cautionary, filled with lessons about innovation, character, leadership, and values.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Pursuit of Happyness',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Biographies & Memoirs'),'At the age of twenty, Milwaukee native Chris Gardner, just out of the Navy, arrived in San Francisco to pursue a promising career in medicine. Considered a prodigy in scientific research, he surprised everyone and himself by setting his sights on the competitive world of high finance. Yet no sooner had he landed an entry-level position at a prestigious firm than Gardner found himself caught in a web of incredibly challenging circumstances that left him as part of the city''s working homeless and with a toddler son. Motivated by the promise he made to himself as a fatherless child to never abandon his own children, the two spent almost a year moving among shelters, ""HO-tels,"" soup lines, and even sleeping in the public restroom of a subway station.
Never giving in to despair, Gardner made an astonishing transformation from being part of the city''s invisible poor to being a powerful player in its financial district.
More than a memoir of Gardner''s financial success, this is the story of a man who breaks his own family''s cycle of men abandoning their children. Mythic, triumphant, and unstintingly honest, The Pursuit of Happyness conjures heroes like Horatio Alger and Antwone Fisher, and appeals to the very essence of the American Dream.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES
 ('Deana Lawson: An Aperture Monograph',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Arts & Photography'),'Deana Lawson is one of the most intriguing photographers of her generation. Over the last ten years, she has created a visionary language to describe identities through intimate portraiture and striking accounts of ceremonies and rituals. Using medium- and large-format cameras, Lawson works with models she meets in the United States and on travels in the Caribbean and Africa to construct arresting, highly structured, and deliberately theatrical scenes animated by an exquisite range of color and attention to surprising details: bedding and furniture in domestic interiors or lush plants in Edenic gardens. The body―often nude―is central. Throughout her work, which invites comparison to the photography of Diane Arbus, Jeff Wall, and Carrie Mae Weems, Lawson seeks to portray the personal and the powerful in black life. Deana Lawson: An Aperture Monograph features forty beautifully reproduced photographs, an essay by the acclaimed writer Zadie Smith, and an expansive conversation with the filmmaker Arthur Jafa.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES
 ('Becoming',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Biographies & Memoirs'),'In a life filled with meaning and accomplishment, Michelle Obama has emerged as one of the most iconic and compelling women of our era. As First Lady of the United States of America—the first African American to serve in that role—she helped create the most welcoming and inclusive White House in history, while also establishing herself as a powerful advocate for women and girls in the U.S. and around the world, dramatically changing the ways that families pursue healthier and more active lives, and standing with her husband as he led America through some of its most harrowing moments. Along the way, she showed us a few dance moves, crushed Carpool Karaoke, and raised two down-to-earth daughters under an unforgiving media glare. 
 
In her memoir, a work of deep reflection and mesmerizing storytelling, Michelle Obama invites readers into her world, chronicling the experiences that have shaped her—from her childhood on the South Side of Chicago to her years as an executive balancing the demands of motherhood and work, to her time spent at the world’s most famous address. With unerring honesty and lively wit, she describes her triumphs and her disappointments, both public and private, telling her full story as she has lived it—in her own words and on her own terms. Warm, wise, and revelatory, Becoming is the deeply personal reckoning of a woman of soul and substance who has steadily defied expectations—and whose story inspires us to do the same.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES
 ('Rich Dad Poor Dad',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Business & Investing'),'Robert Kiyosaki has challenged and changed the way tens of millions of people around the world think about money. With perspectives that often contradict conventional wisdom, Robert has earned a reputation for straight talk, irreverence, and courage. He is regarded worldwide as a passionate advocate for financial education.

"The main reason people struggle financially is because they have spent years in school but learned nothing about money. The result is that people learn to work for money... but never learn to have money work for them." 
-Robert Kiyosaki Rich Dad Poor Dad - The #1 Personal Finance Book of All Time!');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Philosopher''s Stone',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'),'Harry Potter and the Philosopher''s Stone is a fantasy novel written by British author J. K. Rowling. The first novel in the Harry Potter series and Rowling''s debut novel, it follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday, when he receives a letter of acceptance to Hogwarts School of Witchcraft and Wizardry. Harry makes close friends and a few enemies during his first year at the school, and with the help of his friends, Harry faces an attempted comeback by the dark wizard Lord Voldemort, who killed Harry''s parents, but failed to kill Harry when he was just 15 months old.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Chamber of Secrets',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'),'Harry Potter and the Chamber of Secrets is a fantasy novel written by British author J. K. Rowling and the second novel in the Harry Potter series. The plot follows Harry''s second year at Hogwarts School of Witchcraft and Wizardry, during which a series of messages on the walls of the school''s corridors warn that the "Chamber of Secrets" has been opened and that the "heir of Slytherin" would kill all pupils who do not come from all-magical families. These threats are found after attacks which leave residents of the school petrified. Throughout the year, Harry and his friends Ron and Hermione investigate the attacks.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Prisoner of Azkaban',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'),'Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry. Along with friends Ronald Weasley and Hermione Granger, Harry investigates Sirius Black, an escaped prisoner from Azkaban who they believe is one of Lord Voldemort''s old allies.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Goblet of Fire',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'),'Harry Potter and the Goblet of Fire is a fantasy book written by British author J. K. Rowling and the fourth novel in the Harry Potter series. It follows Harry Potter, a wizard in his fourth year at Hogwarts School of Witchcraft and Wizardry and the mystery surrounding the entry of Harry''s name into the Triwizard Tournament, in which he is forced to compete.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Order of the Phoenix',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'), 'Harry Potter and the Order of the Phoenix is a fantasy novel written by British author J. K. Rowling and the fifth novel in the Harry Potter series. It follows Harry Potter''s struggles through his fifth year at Hogwarts School of Witchcraft and Wizardry, including the surreptitious return of the antagonist Lord Voldemort, O.W.L. exams, and an obstructive Ministry of Magic. The novel was published on 21 June 2003 by Bloomsbury in the United Kingdom, Scholastic in the United States, and Raincoast in Canada. Five million copies were sold in the first 24 hours of publication. It is the longest book of the series.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Half-Blood Prince',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'), 'Harry Potter and the Half-Blood Prince is a fantasy novel written by British author J. K. Rowling and the sixth and penultimate novel in the Harry Potter series. Set during protagonist Harry Potter''s sixth year at Hogwarts, the novel explores the past of Harry''s nemesis, Lord Voldemort, and Harry''s preparations for the final battle against Voldemort alongside his headmaster and mentor Albus Dumbledore.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Harry Potter and the Deathly Hallows',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Children''s Books'), 'Harry Potter and the Deathly Hallows is a fantasy novel written by British author J. K. Rowling and the seventh and final novel of the Harry Potter series. The book was released on 21 July 2007, ending the series that began in 1997 with the publication of Harry Potter and the Philosopher''s Stone. It was published in the United Kingdom by Bloomsbury Publishing, in the United States by Scholastic, and in Canada by Raincoast Books. The novel chronicles the events directly following Harry Potter and the Half-Blood Prince (2005) and the final confrontation between the wizards Harry Potter and Lord Voldemort.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Indian Instant Pot Cookbook',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Cookbooks, Food & Wine'), 'It’s tempting to dine out when you think about the intricacies involved in making traditional dals and curries. But Indian Instant Pot Cookbook combines the technique of pressure-cooking with classic Indian foods to give families an easier (and healthier) way of preparing authentic Indian meals. Join Urvashi Pitre, who is best known as the “Butter Chicken Lady,” as she shares the how-to’s of creating delicious Indian dishes of all types in Indian Instant Pot Cookbook.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Japanese Soul Cooking',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Cookbooks, Food & Wine'), 'In Japanese Soul Cooking, Tadashi Ono and Harris Salat introduce you to this irresistible, homey style of cooking. As you explore the range of exciting, satisfying fare, you may recognize some familiar favorites, including ramen, soba, udon, and tempura. Other, lesser known Japanese classics, such as wafu pasta (spaghetti with bold, fragrant toppings like miso meat sauce), tatsuta-age (fried chicken marinated in garlic, ginger, and other Japanese seasonings), and savory omelets with crabmeat and shiitake mushrooms will instantly become standards in your kitchen as well. With foolproof instructions and step-by-step photographs, you’ll soon be knocking out chahan fried rice, mentaiko spaghetti, saikoro steak, and more for friends and family.

Ono and Salat’s fascinating exploration of the surprising origins and global influences behind popular dishes is accompanied by rich location photography that captures the energy and essence of this food in everyday life, bringing beloved Japanese comfort food to Western home cooks for the first time.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Just Bento Cookbook: Everyday Lunches To Go',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Cookbooks, Food & Wine'), 'Bento fever has recently swept across the West, fuelled not just by an interest in cute, decorative food, but by the desire for an economical, healthy approach to eating in these times of recession. A leading light in the popularization of bento has been Makiko Itoh, whose blog, Just Bento, boasts hundreds of thousands of subscribers, all of whom love her delicious recipes and practical bento-making tips.

Now, for the first time, Itoh''s expertise has been packaged in book form. The Just Bento Cookbook contains twenty-five attractive bento menus and more than 150 recipes, all of which have been specially created for this book and are divided into two main sections, Japanese and Not-so-Japanese. The Japanese section includes classic bento menus such as Salted Salmon Bento and Chicken Karaage Bento, while the Not-so-Japanese section shows how Western food can be adapted to the bento concept, with delicious menus such as Summer Vegetable Gratin Bento and Everyone Loves a Pie Bento.

In addition to the recipes, Itoh includes sections on bento-making equipment, bento staples to make and stock, basic cooking techniques, and a glossary. A planning-chart section is included, showing readers how they might organize their weekly bento making.

In a market full of bento books that emphasize the cute and the decorative, this book stands out for its emphasis on the health and economic benefits of the bento, and for the very practical guidelines on how to ensure that a daily bento lunch is something that can easily be incorporated into anyone''s lifestyle. This is the perfect book for the bento beginner, but will also provide a wealth of new bento recipe ideas and tips for Just Bento aficionados.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Tu Casa Mi Casa: Mexican Recipes for the Home Cook',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Cookbooks, Food & Wine'), 'Enrique Olvera is a leading talent on the gastronomic stage, reinventing the cuisine of his native Mexico to global acclaim - yet his true passion is Mexican home cooking.

In Tu Casa Mi Casa he shares 100 of the recipes close to his heart - the core collection of basic Mexican dishes - and encourages readers everywhere to incorporate traditional and contemporary Mexican tastes and ingredients into their recipe repertoire, no matter how far they live from Mexico.

This book includes more than 100 sumptuous photographs of finished food and ingredients, including step-by-step photos to add ultimate clarity to the basics chapter.

These authentic home-cooked recipes are beloved throughout Mexico and beyond - a genuine taste of the country and its traditional cuisine.

Peter Meehan, award-winning food writer, Los Angeles Times editor, former New York Times food critic, and co-founder of Lucky Peach has written the foreword.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Cravings: Hungry for More',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Cookbooks, Food & Wine'), 'Cravings: Hungry for More takes us further into Chrissy’s kitchen . . . and life. It’s a life of pancakes that remind you of blueberry pie, eating onion dip with your glam squad, banana bread that breaks the internet, and a little something called Pad Thai Carbonara. After two years of parenthood, falling in love with different flavors, and relearning the healing power of comfort food, this book is like Chrissy’s new edible diary: recipes for quick-as-a-snap meals; recipes for lighter, brighter, healthier-ish living; and recipes that, well, are gonna put you to bed, holding your belly. And it will have you hungry for more.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('A Long Way Home: A Memoir',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'History'), 'At only five years old, Saroo Brierley got lost on a train in India. Unable to read or write or recall the name of his hometown or even his own last name, he survived alone for weeks on the rough streets of Calcutta before ultimately being transferred to an agency and adopted by a couple in Australia.

Despite his gratitude, Brierley always wondered about his origins. Eventually, with the advent of Google Earth, he had the opportunity to look for the needle in a haystack he once called home, and pore over satellite images for landmarks he might recognize or mathematical equations that might further narrow down the labyrinthine map of India. One day, after years of searching, he miraculously found what he was looking for and set off to find his family.

A Long Way Home is a moving, poignant, and inspirational true story of survival and triumph against incredible odds. It celebrates the importance of never letting go of what drives the human spirit: hope.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The British in India: A Social History of the Raj',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'History'), 'Who of the British went to India, and why? We know about Kipling and Forster, Orwell and Scott, but what of the youthful forestry official, the enterprising boxwallah, the fervid missionary? What motivated them to travel halfway around the globe, what lives did they lead when they got there, and what did they think about it all?

Full of spirited, illuminating anecdotes drawn from long-forgotten memoirs, correspondence, and government documents, The British in India weaves a rich tapestry of the everyday experiences of the Britons who found themselves in "the jewel in the crown" of the British Empire. David Gilmour captures the substance and texture of their work, home, and social lives, and illustrates how these transformed across the several centuries of British presence and rule in the subcontinent, from the East India Company''s first trading station in 1615 to the twilight of the Raj and Partition and Independence in 1947. He takes us through remote hill stations, bustling coastal ports, opulent palaces, regimented cantonments, and dense jungles, revealing the country as seen through British eyes, and wittily reveling in all the particular concerns and contradictions that were a consequence of that limited perspective. The British in India is a breathtaking accomplishment, a vivid and balanced history written with brio, elegance, and erudition.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The History of the Ancient World',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'History'), 'A lively and engaging narrative history showing the common threads in the cultures that gave birth to our own.

This is the first volume in a bold new series that tells the stories of all peoples, connecting historical events from Europe to the Middle East to the far coast of China, while still giving weight to the characteristics of each country. Susan Wise Bauer provides both sweeping scope and vivid attention to the individual lives that give flesh to abstract assertions about human history. This narrative history employs the methods of "history from beneath" - literature, epic traditions, private letters, and accounts - to connect kings and leaders with the lives of those they ruled. The result is an engrossing tapestry of human behavior from which we may draw conclusions about the direction of world events and the causes behind them.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Who Was King Tut?',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'History'), 'Ever since Howard Carter uncovered King Tutankhamun’s tomb in 1922, the young pharaoh has become a symbol of the wealth and mystery of ancient Egypt. Now, a two-and-a-half-year-long museum exhibit of Tut’s treasures is touring major cities in the U.S., drawing record crowds. This Who Was . . . ? is complete with 100 black-andwhite illustrations and explains the life and times of this ancient Egyptian ruler, covering the story of the tomb’s discovery, as well as myths and so-called mummy curses.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Jungle of Stone',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'History'), 'In 1839, rumors of extraordinary yet baffling stone ruins buried within the unmapped jungles of Central America reached two of the world’s most intrepid travelers. Seized by the reports, American diplomat John Lloyd Stephens and British artist Frederick Catherwood—both already celebrated for their adventures in Egypt, the Holy Land, Greece, and Rome—sailed together out of New York Harbor on an expedition into the forbidding rainforests of present-day Honduras, Guatemala, and Mexico. What they found would upend the West’s understanding of human history.

In the tradition of Lost City of Z and In the Kingdom of Ice, former San Francisco Chronicle journalist and Pulitzer Prize finalist William Carlsen reveals the remarkable story of the discovery of the ancient Maya. Enduring disease, war, and the torments of nature and terrain, Stephens and Catherwood meticulously uncovered and documented the remains of an astonishing civilization that had flourished in the Americas at the same time as classic Greece and Rome—and had been its rival in art, architecture, and power. Their masterful book about the experience, written by Stephens and illustrated by Catherwood, became a sensation, hailed by Edgar Allan Poe as “perhaps the most interesting book of travel ever published” and recognized today as the birth of American archaeology. Most important, Stephens and Catherwood were the first to grasp the significance of the Maya remains, understanding that their antiquity and sophistication overturned the West’s assumptions about the development of civilization.

By the time of the flowering of classical Greece (400 b.c.), the Maya were already constructing pyramids and temples around central plazas. Within a few hundred years the structures took on a monumental scale that required millions of man-hours of labor, and technical and organizational expertise. Over the next millennium, dozens of city-states evolved, each governed by powerful lords, some with populations larger than any city in Europe at the time, and connected by road-like causeways of crushed stone. The Maya developed a cohesive, unified cosmology, an array of common gods, a creation story, and a shared artistic and architectural vision. They created stucco and stone monuments and bas reliefs, sculpting figures and hieroglyphs with refined artistic skill. At their peak, an estimated ten million people occupied the Maya’s heartland on the Yucatan Peninsula, a region where only half a million now live. And yet by the time the Spanish reached the “New World,” the Maya had all but disappeared; they would remain a mystery for the next three hundred years.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Silent Patient',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Mystery & Suspense'), 'The Silent Patient is a shocking psychological thriller of a woman''s act of violence against her husband - and of the therapist obsessed with uncovering her motive. 

Alicia Berenson''s life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of London''s most desirable areas. One evening, her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face and then never speaks another word.  

Alicia''s refusal to talk, or give any kind of explanation, turns a domestic tragedy into something far grander, a mystery that captures the public imagination and casts Alicia into notoriety. The price of her art skyrockets, and she, the silent patient, is hidden away from the tabloids and spotlight at the Grove, a secure forensic unit in North London. 

Theo Faber is a criminal psychotherapist who has waited a long time for the opportunity to work with Alicia. His determination to get her to talk and unravel the mystery of why she shot her husband takes him down a twisting path into his own motivations - a search for the truth that threatens to consume him....');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The 18th Abduction',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Mystery & Suspense'), 'For a trio of colleagues, an innocent night out after class ends in a deadly torture session. They vanish without a clue - until a body turns up. With the safety of San Francisco''s entire school system at stake, Lindsay has never been under more pressure. As the chief of police and the press clamor for an arrest in the "school night" case, Lindsay turns to her best friend, investigative journalist Cindy Thomas. Together, Lindsay and Cindy take a new approach to the case, and unexpected facts about the victims leave them stunned. 

While Lindsay is engrossed in her investigation, her husband, Joe Molinari, meets an Eastern European woman who claims to have seen a notorious war criminal - long presumed dead - from her home country. Before Lindsay can verify the woman''s statement, Joe''s mystery informant joins the ranks of the missing women. Lindsay, Joe, and the entire Women''s Murder Club must pull together to protect their city and one another - not from a ghost, but from a true monster.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Then She Was Gone: A Novel',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Mystery & Suspense'), 'Ellie Mack was the perfect daughter. She was fifteen, the youngest of three. She was beloved by her parents, friends, and teachers. She and her boyfriend made a teenaged golden couple. She was days away from an idyllic post-exams summer vacation, with her whole life ahead of her.

And then she was gone.

Now, her mother Laurel Mack is trying to put her life back together. It’s been ten years since her daughter disappeared, seven years since her marriage ended, and only months since the last clue in Ellie’s case was unearthed. So when she meets an unexpectedly charming man in a café, no one is more surprised than Laurel at how quickly their flirtation develops into something deeper. Before she knows it, she’s meeting Floyd’s daughters—and his youngest, Poppy, takes Laurel’s breath away.

Because looking at Poppy is like looking at Ellie. And now, the unanswered questions she’s tried so hard to put to rest begin to haunt Laurel anew. Where did Ellie go? Did she really run away from home, as the police have long suspected, or was there a more sinister reason for her disappearance? Who is Floyd, really? And why does his daughter remind Laurel so viscerally of her own missing girl?');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Woman in the Window: A Novel',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Mystery & Suspense'), 'Anna Fox lives alone—a recluse in her New York City home, unable to venture outside. She spends her day drinking wine (maybe too much), watching old movies, recalling happier times . . . and spying on her neighbors.

Then the Russells move into the house across the way: a father, mother, their teenaged son. The perfect family. But when Anna, gazing out her window one night, sees something she shouldn’t, her world begins to crumble and its shocking secrets are laid bare.

What is real? What is imagined? Who is in danger? Who is in control? In this diabolically gripping thriller, no one—and nothing—is what it seems.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Institute: A Novel',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Mystery & Suspense'), 'In the middle of the night, in a house on a quiet street in suburban Minneapolis, intruders silently murder Luke Ellis’s parents and load him into a black SUV. The operation takes less than two minutes. Luke will wake up at The Institute, in a room that looks just like his own, except there’s no window. And outside his door are other doors, behind which are other kids with special talents—telekinesis and telepathy—who got to this place the same way Luke did: Kalisha, Nick, George, Iris, and ten-year-old Avery Dixon. They are all in Front Half. Others, Luke learns, graduated to Back Half, “like the roach motel,” Kalisha says. “You check in, but you don’t check out.”

In this most sinister of institutions, the director, Mrs. Sigsby, and her staff are ruthlessly dedicated to extracting from these children the force of their extranormal gifts. There are no scruples here. If you go along, you get tokens for the vending machines. If you don’t, punishment is brutal. As each new victim disappears to Back Half, Luke becomes more and more desperate to get out and get help. But no one has ever escaped from the Institute.

As psychically terrifying as Firestarter, and with the spectacular kid power of It, The Institute is Stephen King’s gut-wrenchingly dramatic story of good vs. evil in a world where the good guys don’t always win.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Eleanor Oliphant Is Completely Fine: A Novel',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Romance'), 'Meet Eleanor Oliphant: She struggles with appropriate social skills and tends to say exactly what she’s thinking. Nothing is missing in her carefully timetabled life of avoiding social interactions, where weekends are punctuated by frozen pizza, vodka, and phone chats with Mummy. 

But everything changes when Eleanor meets Raymond, the bumbling and deeply unhygienic IT guy from her office. When she and Raymond together save Sammy, an elderly gentleman who has fallen on the sidewalk, the three become the kinds of friends who rescue one another from the lives of isolation they have each been living. And it is Raymond’s big heart that will ultimately help Eleanor find the way to repair her own profoundly damaged one.

Soon to be a major motion picture produced by Reese Witherspoon, Eleanor Oliphant Is Completely Fine is the smart, warm, and uplifting story of an out-of-the-ordinary heroine whose deadpan weirdness and unconscious wit make for an irresistible journey as she realizes. . . ');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('After We Collided (The After Series)',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Romance'), 'Tessa has everything to lose. Hardin has nothing to lose...except her. AFTER WE COLLIDED...Life will never be the same. #HESSA

After a tumultuous beginning to their relationship, Tessa and Hardin were on the path to making things work. Tessa knew Hardin could be cruel, but when a bombshell revelation is dropped about the origins of their relationship—and Hardin’s mysterious past—Tessa is beside herself.

Hardin will always be...Hardin. But is he really the deep, thoughtful guy Tessa fell madly in love with despite his angry exterior—or has he been a stranger all along? She wishes she could walk away. It’s just not that easy. Not with the memory of passionate nights spent in his arms. His electric touch. His hungry kisses.

Still, Tessa’s not sure she can endure one more broken promise. She put so much on hold for Hardin—school, friends, her mom, a relationship with a guy who really loved her, and now possibly even a promising new career. She needs to move forward with her life.

Hardin knows he made a mistake, possibly the biggest one of his life. He’s not going down without a fight. But can he change? Will he change...for love?');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('After We Fell (The After Series)',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Romance'), 'Tessa and Hardin’s love was complicated before. Now it’s more confusing than ever. AFTER WE FELL...Life will never be the same. #HESSA

Just as Tessa makes the biggest decision of her life, everything changes. Revelations about first her family, and then Hardin’s, throw everything they knew before in doubt and makes their hard-won future together more difficult to claim.

Tessa’s life begins to come unglued. Nothing is what she thought it was. Not her friends. Not her family. The one person she should be able to rely on, Hardin, is furious when he discovers the massive secret she’s been keeping. And rather than being understanding, he turns to sabotage.

Tessa knows Hardin loves her and will do anything to protect her, but there’s a difference between loving someone and being able to have them in your life. This cycle of jealousy, unpredictable anger, and forgiveness is exhausting. She’s never felt so intensely for anyone, so exhilarated by someone’s kiss—but is the irrepressible heat between her and Hardin worth all the drama? Love used to be enough to hold them together. But if Tessa follows her heart now, will it be...the end?');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Crazy Rich Asians Trilogy Box Set',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Romance'), 'New Yorker Rachel Chu does not know that her loving boyfriend, Nicholas Young, also happens to be Singapore’s most eligible bachelor and likely heir to a massive fortune. So when she agrees to spend the summer in Nick’s home, her life unexpectedly becomes an obstacle course of old money, new money, nosy relatives, and scheming social climbers. And that’s all before she discovers the true identity of her long-lost father . . . 
 
This box set includes the entire trilogy: Crazy Rich Asians, China Rich Girlfriend, and Rich People ');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Girl He Used to Know: A Novel',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Romance'), 'Annika (rhymes with Monica) Rose is an English major at the University of Illinois. Anxious in social situations where she finds most people''s behavior confusing, she''d rather be surrounded by the order and discipline of books or the quiet solitude of playing chess.

Jonathan Hoffman joined the chess club and lost his first game―and his heart―to the shy and awkward, yet brilliant and beautiful Annika. He admires her ability to be true to herself, quirks and all, and accepts the challenges involved in pursuing a relationship with her. Jonathan and Annika bring out the best in each other, finding the confidence and courage within themselves to plan a future together. What follows is a tumultuous yet tender love affair that withstands everything except the unforeseen tragedy that forces them apart, shattering their connection and leaving them to navigate their lives alone.

Now, a decade later, fate reunites Annika and Jonathan in Chicago. She''s living the life she wanted as a librarian. He''s a Wall Street whiz, recovering from a divorce and seeking a fresh start. The attraction and strong feelings they once shared are instantly rekindled, but until they confront the fears and anxieties that drove them apart, their second chance will end before it truly begins.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Tiamat''s Wrath: The Expanse, Book 8',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Sci-Fi & Fantasy'), 'The eighth novel in James S. A. Corey''s New York Times best-selling Expanse series - now a major television series. 

Thirteen hundred gates have opened to solar systems around the galaxy. But as humanity builds its interstellar empire in the alien ruins, the mysteries and threats grow deeper. 

In the dead systems where gates lead to stranger things than alien planets, Elvi Okoye begins a desperate search to discover the nature of a genocide that happened before the first human beings existed and to find weapons to fight a war against forces at the edge of the imaginable. But the price of that knowledge may be higher than she can pay. 

At the heart of the empire, Teresa Duarte prepares to take on the burden of her father''s godlike ambition. The sociopathic scientist Paolo Cortázar and the Mephistophelian prisoner James Holden are only two of the dangers in a palace thick with intrigue, but Teresa has a mind of her own and secrets even her father, the emperor, doesn''t guess. 

And throughout the wide human empire, the scattered crew of the Rocinante fights a brave rear-guard action against Duarte''s authoritarian regime. 

Memory of the old order falls away, and a future under Laconia''s eternal rule - and with it, a battle that humanity can only lose - seems more and more certain. Because against the terrors that lie between worlds, courage and ambition will not be enough....');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Children of Time',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Sci-Fi & Fantasy'), 'Adrian Tchaikovksy''s critically acclaimed stand-alone novel Children of Time is the epic story of humanity''s battle for survival on a terraformed planet.

Who will inherit this new Earth?

The last remnants of the human race left a dying Earth, desperate to find a new home among the stars. Following in the footsteps of their ancestors, they discover the greatest treasure of the past age - a world terraformed and prepared for human life.

But all is not right in this new Eden. In the long years since the planet was abandoned, the work of its architects has borne disastrous fruit. The planet is not waiting for them pristine and unoccupied. New masters have turned it from a refuge into mankind''s worst nightmare.

Now two civilizations are on a collision course, both testing the boundaries of what they will do to survive. As the fate of humanity hangs in the balance, who are the true heirs of this new Earth?');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Children of Ruin',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Sci-Fi & Fantasy'), 'Thousands of years ago, Earth''s terraforming program took to the stars. On the world they called Nod, scientists discovered alien life - but it was their mission to overwrite it with the memory of Earth. Then humanity''s great empire fell, and the program''s decisions were lost to time.

Aeons later, humanity and its new spider allies detected fragmentary radio signals between the stars. They dispatched an exploration vessel, hoping to find cousins from old Earth.

But those ancient terraformers woke something on Nod better left undisturbed.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Contact: A Novel',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Sci-Fi & Fantasy'), 'The future is here…in an adventure of cosmic dimension. When a signal is discovered that seems to come from far beyond our solar system, a multinational team of scientists decides to find the source. What follows is an eye-opening journey out to the stars to the most awesome encounter in human history. Who—or what—is out there? Why are they watching us? And what do they want with us?

One of the best science fiction novels about communication with extraterrestrial intelligent beings, Contact is a “stunning and satisfying” (Los Angeles Times) classic.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('The Host',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Sci-Fi & Fantasy'), 'Melanie Stryder refuses to fade away. The earth has been invaded by a species that take over the minds of human hosts while leaving their bodies intact. Wanderer, the invading "soul" who has been given Melanie''s body, didn''t expect to find its former tenant refusing to relinquish possession of her mind.

As Melanie fills Wanderer''s thoughts with visions of Jared, a human who still lives in hiding, Wanderer begins to yearn for a man she''s never met. Reluctant allies, Wanderer and Melanie set off to search for the man they both love.

Featuring one of the most unusual love triangles in literature, THE HOST is a riveting and unforgettable novel about the persistence of love and the essence of what it means to be human. (2008)');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('97 Things to Do Before You Finish High School',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Teens & Young Adult'), 'Want to make a time capsule? Spend a day in silence? Learn how to make beats like a DJ? Or shut down your house party before the police do? Whatever your creative, social, or academic inclinations, you’ll find 97 ways on these pages to amuse, educate, and interest yourself and your friends—helpfully organized into nine categories:
For Your Personal Development
With/for Friends
With/for Family
For Your Body
To Get to Know the World Around You
To Express Yourself
To Benefit Your Community and Environment
Because You Should
Because You''re Only Young Once ');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('God Made Me Special',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Teens & Young Adult'), 'This was given to my daughter when she was in elementary school as a letter to carry with her each day to remind her that God made her special. My daughter was faced with adversity that others often see as a behavior issue; but I knew it was much more than that. I prayed to God and asked him to help and guide me so she could get on the right track, and he helped me with this letter that now has turned into a book. Kids go through so much beginning at a young age, and peer pressure is rapid as they go through different phases of life. Kids are unhappy with themselves, or a part of their body, whether it''s their teeth, nose, ears, body, or hair. When God makes something, he doesn''t make any mistakes; he makes each and every one with their own unique design. It''s important for our kids to know that no matter how they look, they must remember that "God made me special."');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Do You Know Who You Are?',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Teens & Young Adult'), 'What do your music choices reveal about your personality? What kind of a risk-taker are you? How have your changed since you were a kid? Where do you fit in your immediate family? What makes you happy — really, truly happy?

Learn about your skills, dreams, desires, and personality with Do You Know Who You Are?, a guided journal for young adults who want to discover more about themselves. Part quiz book, part self-help book, and part activity book, Do You Know Who You Are? is packed with questionnaires, creative activities, fascinating analysis, and psychological wisdom. Created in collaboration with a professional psychologist who specializes in childhood and adolescence, this book provides an enjoyable and insightful journey for teenage girls who are interested in delving deeper into their true selves.
With fun, bold visuals, thought-provoking quotes, and an interactive fill-in format, Do You Know Who You Are? speaks directly to young adult readers. It offers helpful tips and clear guidance, encouraging teens to develop a strong sense of self, and reassuring them that it''s just fine to be exactly who they are.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('Frenemies: What to Do When Friends Turn Mean',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Teens & Young Adult'), 'Friends and enemies--sometimes it''s hard to tell the two apart. Especially when some people seem to be both. In her bestselling book Mean Girls, Hayley DiMarco counseled teens about how to handle mean girls at school or church who were making their lives miserable. But what''s a girl to do when her own friends are the ones doing those mean and hurtful things--being her BFF one day but betraying her the next? Frenemies helps girls figure it out.
In this new book from big-sister mentor Hayley DiMarco, teens will learn why friends act the way they do and how they should react when the mean people in their lives are the people they love and trust the most.');
INSERT INTO BOOKSTORE.BOOK (TITLE, CATEGORY_ID, SUMMARY) VALUES ('A Self-Guided Workbook for Highly Effective Teens',(SELECT ID FROM BOOKSTORE.BOOK_CATEGORY WHERE CATEGORY_NAME = 'Teens & Young Adult'), 'A Self-Guided Workbook for Highly Effective Teens by Sean Covey is a short, quick, and user friendly companion to the bestselling The 7 Habits of Highly Effective Teens. This compact workbook provides the same engaging activities, interactives, and self-evaluations, but now it''s graphically more engaging to help teens understand and apply the power of the Habits.');










--Book_Author
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Monk Who Sold His Ferrari'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Robin Sharma'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Alchemist'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Paulo Coelho'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Immortals of Meluha'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Amish Tripathi'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Secret of the Nagas'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Amish Tripathi'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Oath of the Vayuputras'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Amish Tripathi'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Steve Jobs'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Walter Isaacson'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Pursuit of Happyness'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Chris Gardner'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Deana Lawson: An Aperture Monograph'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Zadie Smith'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Becoming'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Michelle Obama'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Rich Dad Poor Dad'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Robert T. Kiyosaki'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Philosopher''s Stone'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Chamber of Secrets'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Prisoner of Azkaban'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Goblet of Fire'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Order of the Phoenix'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Half-Blood Prince'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Deathly Hallows'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'J. K. Rowling'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Indian Instant Pot Cookbook'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Urvashi Pitre'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Japanese Soul Cooking'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Tadashi Ono'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Japanese Soul Cooking'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Harris Salat'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Just Bento Cookbook: Everyday Lunches To Go'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Makiko Itoh'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Tu Casa Mi Casa: Mexican Recipes for the Home Cook'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Enrique Olvera'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Cravings: Hungry for More'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Chrissy Teigen'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Cravings: Hungry for More'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Adeena Sussman'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'A Long Way Home: A Memoir'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Saroo Brierley'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The British in India: A Social History of the Raj'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'David Gilmour'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The History of the Ancient World'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Susan Wise Bauer'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Who Was King Tut?'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Roberta Edwards'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Jungle of Stone'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'William Carlsen'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Silent Patient'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Alex Michaelides'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The 18th Abduction'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'James Patterson'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The 18th Abduction'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Maxine Paetro'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Then She Was Gone: A Novel'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Lisa Jewell'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Woman in the Window: A Novel'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'A. J Finn'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Institute: A Novel'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Stephen King'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Eleanor Oliphant Is Completely Fine: A Novel'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Gail Honeyman'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'After We Collided (The After Series)'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Anna Todd'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'After We Fell (The After Series)'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Anna Todd'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Crazy Rich Asians Trilogy Box Set'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Kevin Kwan'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Girl He Used to Know: A Novel'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Tracey Garvis Graves'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Tiamat''s Wrath: The Expanse, Book 8'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'James S. A. Corey'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Children of Time'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Adrian Tchaikovsky'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Children of Ruin'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Adrian Tchaikovsky'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Contact: A Novel'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Carl Sagan'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Host'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Stephenie Meyer'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = '97 Things to Do Before You Finish High School'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Erika Stalder'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = '97 Things to Do Before You Finish High School'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Steven Jenkins'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'God Made Me Special'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Tanynika Pace'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Do You Know Who You Are?'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Megan Kaye'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Frenemies: What to Do When Friends Turn Mean'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Hayley DiMarco'));
INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'A Self-Guided Workbook for Highly Effective Teens'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Sean Covey'));













INSERT INTO BOOKSTORE.BOOK_AUTHOR VALUES ((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Monk Who Sold His Ferrari'), (SELECT ID FROM BOOKSTORE.AUTHOR WHERE AUTHOR_NAME = 'Amish Tripathi'));

--Book_Format
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Monk Who Sold His Ferrari'), '9780062515674', '978-0062515674', 'PAPERBACK', 11.83, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Monk Who Sold His Ferrari'), '9780062515674', '978-0062515674', 'HARDCOVER', 33.32, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Alchemist'), '0062315005', '978-0062315007', 'PAPERBACK', 10.27, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Alchemist'), '0062315005', '978-0062315007', 'HARDCOVER', 18.99, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Immortals of Meluha'), '9380658745', '978-9380658745', 'PAPERBACK', 13.26, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Immortals of Meluha'), '9380658745', '978-9380658745', 'HARDCOVER', 36.02, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Secret of the Nagas'), '9381626340', '978-9381626344', 'PAPERBACK', 7.89, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Secret of the Nagas'), '9381626340', '978-9381626344', 'HARDCOVER', 40.98, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Oath of the Vayuputras'), '9382618341', '978-9382618341', 'PAPERBACK', 17.42, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Oath of the Vayuputras'), '9382618341', '978-9382618341', 'HARDCOVER', 53.32, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Steve Jobs'), '1451648537', '978-1451648539', 'PAPERBACK', 15.49, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Steve Jobs'), '1451648537', '978-1451648539', 'HARDCOVER', 55.32, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Pursuit of Happyness'), '0060744871', '978-0060744878', 'PAPERBACK', 9.80, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Pursuit of Happyness'), '0060744871', '978-0060744878', 'HARDCOVER', 14.49, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Philosopher''s Stone'), '0-7475-3269-9', '978-0-7475-3269-9', 'HARDCOVER', 29.99, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Chamber of Secrets'), '0-7475-3849-2', '978-0-7475-3849-2', 'HARDCOVER', 27.91, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Prisoner of Azkaban'), '0-7475-4215-5', '978-0-7475-4215-5', 'HARDCOVER', 28.40, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Goblet of Fire'), '0-7475-4624-X', '978-0-7475-4624-X', 'HARDCOVER', 28.79, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Order of the Phoenix'), '0-7475-5100-6', '978-0-7475-5100-6', 'HARDCOVER', 11.85, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Half-Blood Prince'), '0-7475-8108-8', '978-0-7475-8108-8', 'HARDCOVER', 11.99, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Harry Potter and the Deathly Hallows'), '0-545-01022-5', '978-0-545-01022-5', 'HARDCOVER', 13.59, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Indian Instant Pot Cookbook'), '1939754542', '978-1939754547', 'HARDCOVER', 9.89, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Japanese Soul Cooking'), '1607743523', '978-1607743521', 'HARDCOVER', 19.79, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Just Bento Cookbook: Everyday Lunches To Go'), '9781568363936', '978-1568363936', 'HARDCOVER', 10.20, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Tu Casa Mi Casa: Mexican Recipes for the Home Cook'), '0714878057', '978-0714878058', 'HARDCOVER', 23.97, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Cravings: Hungry for More'), '1524759724', '978-1524759728', 'HARDCOVER', 18.30, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'A Long Way Home: A Memoir'), '0425276198', '978-0425276198', 'HARDCOVER', 21.97, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The British in India: A Social History of the Raj'), '0425279851', '978-0425279851', 'HARDCOVER', 23, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The History of the Ancient World'), '0425279821', '978-0425279821', 'HARDCOVER', 18.99, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Who Was King Tut?'), '0448443600', '978-0448443607', 'HARDCOVER', 8.55, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Jungle of Stone'), '0062407406', '978-0062407405', 'HARDCOVER', 48.30, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Silent Patient'), '0062407306', '978-0062407306', 'HARDCOVER', 16.20, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The 18th Abduction'), '0062407206', '978-0062407206', 'HARDCOVER', 14.00, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Then She Was Gone: A Novel'), '1501154656', '978-1501154652', 'HARDCOVER', 35.99, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Woman in the Window: A Novel'), '0062678426', '978-0062678423', 'HARDCOVER', 16.55, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Institute: A Novel'), '1982110562', '978-1982110567', 'HARDCOVER', 19.49, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Eleanor Oliphant Is Completely Fine: A Novel'), '0735220697', '978-0735220690', 'HARDCOVER', 25.23, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'After We Collided (The After Series)'), '1476792496', '978-1476792491', 'HARDCOVER', 15.00, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'After We Fell (The After Series)'), '9781476792507', '978-1476792507', 'HARDCOVER', 18.00, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Crazy Rich Asians Trilogy Box Set'), '0525566651', '978-0525566656', 'HARDCOVER', 35.99, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Girl He Used to Know: A Novel'), '1250200350', '978-1250200358', 'HARDCOVER', 17.70, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Tiamat''s Wrath: The Expanse, Book 8'), '1250200351', '978-1250200351', 'HARDCOVER', 19.49, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Children of Time'), '1250200352', '978-1250200352', 'HARDCOVER', 92.97, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Children of Ruin'), '031645253X', '978-0316452533', 'HARDCOVER', 95.75, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Contact: A Novel'), '1501197983', '978-1501197987', 'HARDCOVER', 10.83, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'The Host'), '0316068055', '978-0316068055', 'HARDCOVER', 15.00, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = '97 Things to Do Before You Finish High School'), '0979017300', '978-0979017308', 'HARDCOVER', 5.68, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'God Made Me Special'), '1643001604', '978-1643001609', 'HARDCOVER', 15.45, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Do You Know Who You Are?'), '1465416498', '978-1465416490', 'HARDCOVER', 18, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'Frenemies: What to Do When Friends Turn Mean'), '0800733045', '978-0800733049', 'HARDCOVER', 16, 100);
INSERT INTO BOOKSTORE.BOOK_FORMAT (ID, ISBN_10, ISBN_13, FORMAT, PRICE, NUM_COPIES) VALUES
((SELECT ID FROM BOOKSTORE.BOOK WHERE TITLE = 'A Self-Guided Workbook for Highly Effective Teens'), '1633532712', '978-1633532717', 'HARDCOVER', 18.00, 100);













--Order_Status
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (1, 'PENDING', 'Pending');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (2, 'DISPATCHING', 'Dispatching');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (3, 'DISPATCHED', 'Dispatched');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (4, 'OUT_FOR_DELIVERY', 'Out for delivery');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (5, 'DELIVERED', 'Delivered');

SELECT A.ID, A.TITLE, A.AUTHORS, A.CATEGORY, A.IMAGE, A.SUMMARY, B.ISBN_10, B.ISBN_13, B.FORMAT, B.PRICE, B.NUM_COPIES FROM BOOKSTORE.BOOK A INNER JOIN BOOKSTORE.BOOK_FORMAT B ON A.TITLE = B.TITLE AND B.FORMAT = 'PAPERBACK' AND A.ID = 1;
SELECT A.ID, A.TITLE, A.AUTHORS, A.CATEGORY, A.IMAGE, A.SUMMARY, B.ISBN_10, B.ISBN_13, B.FORMAT, B.PRICE, B.NUM_COPIES FROM BOOKSTORE.BOOK A INNER JOIN BOOKSTORE.BOOK_FORMAT B ON A.TITLE = B.TITLE AND A.ID = 1;

BOOKSTORE.BOOK
All

================================================================================
OLD
CREATE TABLE BOOKSTORE.BOOK_CATEGORY (
    CATEGORY_NAME VARCHAR(30) PRIMARY KEY,
    ID INT NOT NULL
);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Arts & Photography', 1);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Biographies & Memoirs', 2);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Business & Investing', 3);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Children''s Books', 4);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Cookbooks, Food & Wine', 5);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('History', 6);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Literature & Fiction', 7);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Mystery & Suspense', 8);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Romance', 9);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Sci-Fi & Fantasy', 10);
INSERT INTO BOOKSTORE.BOOK_CATEGORY VALUES ('Teens & Young Adult', 11);

CREATE TABLE BOOKSTORE.BOOK (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(50),
    AUTHORS VARCHAR(150),
    CATEGORY VARCHAR(30) REFERENCES BOOK_CATEGORY,
    IMAGE BLOB,
    SUMMARY VARCHAR(3000),
    CREATED_ON TIMESTAMP,
    CREATED_BY VARCHAR(50),
    UPDATED_ON TIMESTAMP,
    UPDATED_BY VARCHAR(50)
);
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('The Monk Who Sold His Ferrari','Robin Sharma','Literature & Fiction','The book develops around two characters, Julian Mantle and his best friend John, in the form of conversation. Julian narrates his spiritual experiences during a Himalayan journey which he undertook after selling his holiday home and red Ferrari.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('The Alchemist','Paulo Coelho','Literature & Fiction','The story of the treasures Santiago finds along the way teaches us, as only a few stories can, about the essential wisdom of listening to our hearts, learning to read the omens strewn along life''s path, and, above all, following our dreams.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('The Immortals of Meluha','Amish Tripathi','Literature & Fiction','1900 BC. In what modern Indians mistakenly call the Indus Valley Civilisation. The inhabitants of that period called it the land of Meluha – a near perfect empire created many centuries earlier by Lord Ram, one of the greatest monarchs that ever lived. This once proud empire and its Suryavanshi rulers face severe perils as its primary river, the revered Saraswati, is slowly drying to extinction. They also face devastating terrorist attacks from the east, the land of the Chandravanshis. To make matters worse, the Chandravanshis appear to have allied with the Nagas, an ostracised and sinister race of deformed humans with astonishing martial skills. The only hope for the Suryavanshis is an ancient legend: ‘When evil reaches epic proportions, when all seems lost, when it appears that your enemies have triumphed, a hero will emerge.’ Is the rough-hewn Tibetan immigrant Shiva, really that hero? And does he want to be that hero at all? Drawn suddenly to his destiny, by duty as well as by love, will Shiva lead the Suryavanshi vengeance and destroy evil? This is the first book in a trilogy on Shiva, the simple man whose karma re-cast him as our Mahadev, the God of Gods.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('The Secret of the Nagas','Amish Tripathi','Literature & Fiction','Today, He is a God. 4000 years ago, He was just a man. The hunt is on. The sinister Naga warrior has killed his friend Brahaspati and now stalks his wife Sati. Shiva, the Tibetan immigrant who is the prophesied destroyer of evil, will not rest till he finds his demonic adversary. His vengeance and the path to evil will lead him to the door of the Nagas, the serpent people. Of that he is certain. The evidence of the malevolent rise of evil is everywhere. A kingdom is dying as it is held to ransom for a miracle drug. A crown prince is murdered. The Vasudevs Shiva''s philosopher guides betray his unquestioning faith as they take the aid of the dark side. Even the perfect empire, Meluha is riddled with a terrible secret in Maika, the city of births. Unknown to Shiva, a master puppeteer is playing a grand game. In a journey that will take him across the length and breadth of ancient India, Shiva searches for the truth in a land of deadly mysteries only to find that nothing is what it seems. Fierce battles will be fought. Surprising alliances will be forged. Unbelievable secrets will be revealed in this second book of the Shiva Trilogy, the sequel to the #1 national bestseller, The Immortals of Meluha.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('The Oath of the Vayuputras','Amish Tripathi','Literature & Fiction','Today, Shiva is a god. But four thousand years ago, he was just a man - until he brought his people to Meluha, a near-perfect empire founded by the great king Lord Ram. There he discovered he was the Neelkanth, a barbarian long prophesied to be Meluha''s saviour.
But in his hour of victory fighting the Chandravanshis - Meluha''s enemy - he discovered they had their own prophecy. 
Now he must fight to uncover the treachery within his inner circle, and unmask those who are about to destroy all that he has fought for. Shiva is about to learn that good and evil are two sides of the same coin...', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('Steve Jobs','Walter Isaacson','Biographies & Memoirs','Based on more than forty interviews with Jobs conducted over two years—as well as interviews with more than a hundred family members, friends, adversaries, competitors, and colleagues—Walter Isaacson has written a riveting story of the roller-coaster life and searingly intense personality of a creative entrepreneur whose passion for perfection and ferocious drive revolutionized six industries: personal computers, animated movies, music, phones, tablet computing, and digital publishing.
At a time when America is seeking ways to sustain its innovative edge, and when societies around the world are trying to build digital-age economies, Jobs stands as the ultimate icon of inventiveness and applied imagination. He knew that the best way to create value in the twenty-first century was to connect creativity with technology. He built a company where leaps of the imagination were combined with remarkable feats of engineering.  
Although Jobs cooperated with this book, he asked for no control over what was written nor even the right to read it before it was published. He put nothing off-limits. He encouraged the people he knew to speak honestly. And Jobs speaks candidly, sometimes brutally so, about the people he worked with and competed against. His friends, foes, and colleagues provide an unvarnished view of the passions, perfectionism, obsessions, artistry, devilry, and compulsion for control that shaped his approach to business and the innovative products that resulted.
Driven by demons, Jobs could drive those around him to fury and despair. But his personality and products were interrelated, just as Apple’s hardware and software tended to be, as if part of an integrated system. His tale is instructive and cautionary, filled with lessons about innovation, character, leadership, and values.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES ('The Pursuit of Happyness','Chris Gardner','Biographies & Memoirs','At the age of twenty, Milwaukee native Chris Gardner, just out of the Navy, arrived in San Francisco to pursue a promising career in medicine. Considered a prodigy in scientific research, he surprised everyone and himself by setting his sights on the competitive world of high finance. Yet no sooner had he landed an entry-level position at a prestigious firm than Gardner found himself caught in a web of incredibly challenging circumstances that left him as part of the city''s working homeless and with a toddler son. Motivated by the promise he made to himself as a fatherless child to never abandon his own children, the two spent almost a year moving among shelters, ""HO-tels,"" soup lines, and even sleeping in the public restroom of a subway station.
Never giving in to despair, Gardner made an astonishing transformation from being part of the city''s invisible poor to being a powerful player in its financial district.
More than a memoir of Gardner''s financial success, this is the story of a man who breaks his own family''s cycle of men abandoning their children. Mythic, triumphant, and unstintingly honest, The Pursuit of Happyness conjures heroes like Horatio Alger and Antwone Fisher, and appeals to the very essence of the American Dream.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES
 ('Deana Lawson: An Aperture Monograph','Zadie Smith','Arts & Photography','Deana Lawson is one of the most intriguing photographers of her generation. Over the last ten years, she has created a visionary language to describe identities through intimate portraiture and striking accounts of ceremonies and rituals. Using medium- and large-format cameras, Lawson works with models she meets in the United States and on travels in the Caribbean and Africa to construct arresting, highly structured, and deliberately theatrical scenes animated by an exquisite range of color and attention to surprising details: bedding and furniture in domestic interiors or lush plants in Edenic gardens. The body―often nude―is central. Throughout her work, which invites comparison to the photography of Diane Arbus, Jeff Wall, and Carrie Mae Weems, Lawson seeks to portray the personal and the powerful in black life. Deana Lawson: An Aperture Monograph features forty beautifully reproduced photographs, an essay by the acclaimed writer Zadie Smith, and an expansive conversation with the filmmaker Arthur Jafa.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES
 ('Becoming','Michelle Obama','Biographies & Memoirs','In a life filled with meaning and accomplishment, Michelle Obama has emerged as one of the most iconic and compelling women of our era. As First Lady of the United States of America—the first African American to serve in that role—she helped create the most welcoming and inclusive White House in history, while also establishing herself as a powerful advocate for women and girls in the U.S. and around the world, dramatically changing the ways that families pursue healthier and more active lives, and standing with her husband as he led America through some of its most harrowing moments. Along the way, she showed us a few dance moves, crushed Carpool Karaoke, and raised two down-to-earth daughters under an unforgiving media glare. 
 
In her memoir, a work of deep reflection and mesmerizing storytelling, Michelle Obama invites readers into her world, chronicling the experiences that have shaped her—from her childhood on the South Side of Chicago to her years as an executive balancing the demands of motherhood and work, to her time spent at the world’s most famous address. With unerring honesty and lively wit, she describes her triumphs and her disappointments, both public and private, telling her full story as she has lived it—in her own words and on her own terms. Warm, wise, and revelatory, Becoming is the deeply personal reckoning of a woman of soul and substance who has steadily defied expectations—and whose story inspires us to do the same.', current_timestamp(), 'Kedar');
INSERT INTO BOOKSTORE.BOOK (Title, Authors, Category, Summary, CREATED_ON, CREATED_BY) VALUES
 ('Rich Dad Poor Dad','Robert T. Kiyosaki','Business & Investing','Robert Kiyosaki has challenged and changed the way tens of millions of people around the world think about money. With perspectives that often contradict conventional wisdom, Robert has earned a reputation for straight talk, irreverence, and courage. He is regarded worldwide as a passionate advocate for financial education.

"The main reason people struggle financially is because they have spent years in school but learned nothing about money. The result is that people learn to work for money... but never learn to have money work for them." 
-Robert Kiyosaki Rich Dad Poor Dad - The #1 Personal Finance Book of All Time!', current_timestamp(), 'Kedar');

CREATE TABLE BOOKSTORE.BOOK_FORMAT (
    TITLE VARCHAR(50) REFERENCES BOOK,
    ISBN_10 VARCHAR(20),
    ISBN_13 VARCHAR(20),
    FORMAT VARCHAR(10) CHECK (FORMAT IN ('PAPERBACK' , 'HARDCOVER')),
    PRICE FLOAT(5 , 2 ),
    NUM_COPIES INT,
	CREATED_ON TIMESTAMP,
    CREATED_BY VARCHAR(50),
    UPDATED_ON TIMESTAMP,
    UPDATED_BY VARCHAR(50)
);