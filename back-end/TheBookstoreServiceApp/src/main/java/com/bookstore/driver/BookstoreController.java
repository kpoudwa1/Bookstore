package com.bookstore.driver;

import java.util.List;
import java.util.Optional;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins="http://localhost:3000")
@RequestMapping("/bookstore")
public class BookstoreController
{
	@Autowired
	BookRepository bookRepo;
	private static Logger log = LogManager.getLogger(BookstoreController.class);
	
	/** 
	 * Function for getting a list of book name and images
	 */
	@GetMapping("/books/")
	public List<Object[]> getBooksList()
	{
		log.info("Getting the list of all books");
		return bookRepo.findList();
	}
	
	/** 
	 * Function for getting the details of a book
	 * @return 
	 */
	@GetMapping("/booksDetails/{id}")
	public Optional<Book> getBookDetails(@PathVariable int id)
	{
		log.info("Getting the details for book with id " + id);
		return bookRepo.findById(id);
	}
	
	/** 
	 * Function for getting a list of book name and images by performing
	 *  a search on the book title
	 * @return 
	 */
	@GetMapping("/books/{title}")
	public List<Object[]> getBookByTitle(@PathVariable String title)
	{
		log.info("Getting the details for book with title " + title);
		return bookRepo.findByTitle(title);
	}
}