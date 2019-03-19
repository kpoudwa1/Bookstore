--Schemas
--bookstore - For storing information related to books
--users - For storing information related to users

--###############################################################
--								DDL
--###############################################################

--Books
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

--Book_Format
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

--Book_Category
CREATE TABLE BOOKSTORE.BOOK_CATEGORY (
    CATEGORY_NAME VARCHAR(30) PRIMARY KEY,
    ID INT NOT NULL
);

--###############################################################
--								DML
--###############################################################
--Book_Category
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

--Books
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
