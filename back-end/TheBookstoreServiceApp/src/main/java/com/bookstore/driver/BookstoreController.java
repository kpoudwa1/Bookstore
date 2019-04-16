package com.bookstore.driver;

import java.util.ArrayList;
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

import com.bookstore.exceptions.BookNotFoundException;

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
	public List<Book> getBookByTitle(@PathVariable String title)
	{
		log.info("Getting the details for book with title " + title);
		List<Object[]> booksObject = bookRepo.findByTitle(title);
		
		//Creating a List<Book> from List<Object[]> 
		List<Book> books = new ArrayList<Book>();
		for(Object obj[]: booksObject)
		{
			Book book = new Book();
			book.setId((int) obj[0]);
			book.setTitle((String) obj[1]);
			book.setImage((byte[]) obj[2]);

			books.add(book);
		}
		
		System.out.println(books);
		System.out.println(books.size());
		if(books != null && books.size() == 0)
			throw new BookNotFoundException("The book with the title '" + title + "' cannot be found");
		
		return books;
	}
}