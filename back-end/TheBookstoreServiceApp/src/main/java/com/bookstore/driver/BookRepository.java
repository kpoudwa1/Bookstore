package com.bookstore.driver;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookRepository extends JpaRepository<Book, Integer>
{
	public List<BooksListProjection> findByTitleContaining(String title);
	
	public List<BooksListProjection> findByBookCategoryId(int id);
	
	public Book findFirstByOrderByIdDesc();
}