package com.bookstore.driver;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer>
{
	public Optional<User> findOneByEmailAndPassword(String email, String password);
	
	public Optional<User> findIdByEmail(String email);
	
	public UserProjection findOneByEmail(String email);
	
	@Query(value="SELECT B.TITLE, B.IMAGE ,P.QUANTITY, P.ORDER_DATE FROM BOOKSTORE.PURCHASES P INNER JOIN BOOKSTORE.BOOK B ON P.BOOK_ID = B.ID WHERE USER_ID = :userId AND STATUS = :status ORDER BY B.ID ASC;", nativeQuery=true)
	public List<Object[]> findPreviousPurchases(@Param("userId") int userId, @Param("status") int status);
	
	//@Query(value="SELECT T.BOOK_ID, B.IMAGE, O.DISPLAY_NAME, T.STATUS_DATE FROM BOOKSTORE.TRACK_ORDER T INNER JOIN BOOKSTORE.BOOK B ON B.ID = T.BOOK_ID INNER JOIN BOOKSTORE.ORDER_STATUS O ON O.ID = T.STATUS WHERE BOOK_ID IN (SELECT DISTINCT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = :userId AND BOOK_ID NOT IN (SELECT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = :userId AND STATUS = :status)) ORDER BY STATUS_DATE, STATUS ASC;", nativeQuery=true)
	@Query(value="SELECT BOOK_ID, B.IMAGE, O.DISPLAY_NAME, STATUS_DATE FROM (SELECT BOOK_ID, MAX(STATUS) AS STATUS, STATUS_DATE FROM BOOKSTORE.TRACK_ORDER WHERE BOOK_ID IN (SELECT DISTINCT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = :userId AND BOOK_ID NOT IN (SELECT BOOK_ID FROM BOOKSTORE.TRACK_ORDER WHERE USER_ID = :userId AND STATUS = :status)) GROUP BY BOOK_ID ORDER BY BOOK_ID ASC) AS T  INNER JOIN BOOKSTORE.BOOK B ON B.ID = T.BOOK_ID INNER JOIN BOOKSTORE.ORDER_STATUS O ON O.ID = T.STATUS;", nativeQuery=true)
	public List<Object[]> findOrders(@Param("userId") int userId, @Param("status") int status);
}