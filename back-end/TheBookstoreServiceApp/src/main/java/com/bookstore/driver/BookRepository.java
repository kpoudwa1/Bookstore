package com.bookstore.driver;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface BookRepository extends JpaRepository<Book, Integer>
{
	@Query(value = "SELECT ID, TITLE, IMAGE FROM BOOK", nativeQuery = true)
	public List<Object[]> findList();
	
	/*
	 * @Query(value = "SELECT ID, TITLE, IMAGE FROM BOOK WHERE TITLE LIKE %:title%",
	 * nativeQuery = true) public List<Object[]> findByTitle(@Param("title") String
	 * title);
	 */
	
	@Query(value = "SELECT ID, TITLE, IMAGE FROM BOOK WHERE TITLE LIKE %:title%", nativeQuery = true)
	public List<Object[]> findByTitle(@Param("title") String title);
}