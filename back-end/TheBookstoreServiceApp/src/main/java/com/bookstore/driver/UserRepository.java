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
	
	public UserProjection findOneByEmail(String email);
	
	@Query(value="SELECT B.TITLE, B.IMAGE ,P.QUANTITY, P.ORDER_DATE FROM BOOKSTORE.PURCHASES P INNER JOIN BOOKSTORE.BOOK B ON P.ID = B.ID WHERE USER_ID = :userId AND STATUS = :status ORDER BY B.ID ASC;", nativeQuery=true)
	public List<Object[]> findPreviousPurchases(@Param("userId") int userId, @Param("status") int status);
}