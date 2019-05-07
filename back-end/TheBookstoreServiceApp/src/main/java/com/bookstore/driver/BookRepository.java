package com.bookstore.driver;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.bookstore.driver.BookCategory;
import com.bookstore.driver.Book;

@Repository
public interface BookRepository extends JpaRepository<Book, Integer>
{
	public List<BooksListProjection> findByTitleContaining(String title);
	
	//List<Book> ;
	//public List<Book> findByBookCategoryId(int id);
	public List<BooksListProjection> findByBookCategoryId(int id);
}