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
	STATUS INT REFERENCES ORDER_STATUS,
	STATUS_DATE DATE
);

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

--Order_Status
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (1, 'PENDING', 'Pending');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (2, 'DISPATCHING', 'Dispatching');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (3, 'DISPATCHED', 'Dispatched');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (4, 'OUT_FOR_DELIVERY', 'Out for delivery');
INSERT INTO BOOKSTORE.ORDER_STATUS VALUES (5, 'DELIVERED', 'Delivered');

SELECT A.ID, A.TITLE, A.AUTHORS, A.CATEGORY, A.IMAGE, A.SUMMARY, B.ISBN_10, B.ISBN_13, B.FORMAT, B.PRICE, B.NUM_COPIES FROM BOOKSTORE.BOOK A INNER JOIN BOOKSTORE.BOOK_FORMAT B ON A.TITLE = B.TITLE AND B.FORMAT = 'PAPERBACK' AND A.ID = 1;
SELECT A.ID, A.TITLE, A.AUTHORS, A.CATEGORY, A.IMAGE, A.SUMMARY, B.ISBN_10, B.ISBN_13, B.FORMAT, B.PRICE, B.NUM_COPIES FROM BOOKSTORE.BOOK A INNER JOIN BOOKSTORE.BOOK_FORMAT B ON A.TITLE = B.TITLE AND A.ID = 1;

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