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

import com.bookstore.exceptions.BookNotFoundException;

@RestController
@CrossOrigin(origins="http://localhost:3000")
@RequestMapping("/bookstore/books")
public class BookstoreController
{
	@Autowired
	BookRepository bookRepo;
	private static Logger log = LogManager.getLogger(BookstoreController.class);
	
	/** 
	 * Function for searching whether a book exists in the repository
	 *  on the basis of title.
	 * @param title The title for the book which is to be checked.
	 * @return Returns a projection list of books.
	 * @exception BookNotFoundException Returns an exception when the
	 *  book does not exists in the repository.
	 */
	@GetMapping("/searchByTitle/{title}")
	public List<BooksListProjection> getBookByTitle(@PathVariable String title)
	{
		log.info("Searching for the book with title '" + title + "'");
		
		List<BooksListProjection> booksList = bookRepo.findByTitleContaining(title);
		if(booksList != null && booksList.size() == 0)
			throw new BookNotFoundException("Sorry! The book with the title '" + title + "' cannot be found");
		
		return booksList;
	}
	
	/** 
	 * Function for searching whether a book exists in the repository
	 *  on the basis of id.
	 * @param id The id for the book which is to be checked.
	 * @return Returns the book if it exists in the repository.
	 * @exception BookNotFoundException Returns an exception when the
	 *  book does not exists in the repository.
	 */
	
	@GetMapping("/searchById/{id}")
	public Optional<Book> getBookById(@PathVariable int id)
	{
		log.info("Searching for the book with id '" + id + "'");
		
		Optional<Book> book = bookRepo.findById(id);
		
		if(!book.isPresent())
			throw new BookNotFoundException("Sorry! The book with the id '" + id + "' cannot be found");
		
		return book;
	}
	
	/** 
	 * Function for getting the details of a book on the basis of id.
	 * @param id The id for the book for which details have to be
	 *  fetched.
	 * @return Returns the details of the book.
	 * @exception BookNotFoundException Returns an exception if an
	 *  invalid id is passed.
	 */
	@GetMapping("/getBookDetails/{id}")
	public Optional<Book> getBookDetails(@PathVariable int id)
	{
		log.info("Getting the details for book with id '" + id + "'");
		
		Optional<Book> bookDetails = bookRepo.findById(id);
		
		if(!bookDetails.isPresent())
			throw new BookNotFoundException("Sorry! Invalid book id '" + id + "'");
		
		return bookDetails;
	}
	
	/**
	 * Function for getting a list of books on the basis of book
	 *  category.
	 * @param id Category id of which books are to be searched
	 * @return Returns a projection list of books.
	 */
	@GetMapping("/getBooksByCategory/{id}")
	public List<BooksListProjection> getbooksByCategory(@PathVariable int id)
	{
		log.info("Getting the details for book with category id '" + id + "'");
		
		return bookRepo.findByBookCategoryId(id);
	}
}