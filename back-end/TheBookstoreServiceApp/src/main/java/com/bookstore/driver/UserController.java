package com.bookstore.driver;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bookstore.exceptions.UserAlreadyExists;
import com.bookstore.exceptions.UserNotFoundException;

@RestController
@CrossOrigin(origins="http://localhost:3000")
@RequestMapping("/user")
public class UserController
{
	@Autowired
	UserRepository userRepo;
	private static Logger log = LogManager.getLogger(UserController.class);
	//TODO create service for sign up

	@PostMapping("/create/")
	public ResponseEntity<Void> createUser(@RequestBody User user)
	{
		log.info("Create user service called !!!!!!!!!!!!!!!!!!!!!!");
		log.info(user);
		
		//Validation if email already exists
		UserProjection existsUser = userRepo.findOneByEmail(user.getEmail());
		
		if(existsUser != null)
			throw new UserAlreadyExists("User id with email " + user.getEmail() + " already exists !");
		
		//Handling the date issue
		Calendar cal = Calendar.getInstance();
		cal.setTime(user.getDob());
		cal.add(Calendar.DATE, 1);
		user.setDob(cal.getTime());

		userRepo.save(user);
		log.info("User stored in datbase");
		
		return ResponseEntity.created(null).build();
	}
	
	//TODO create service for login
	@PostMapping("/authenticate/")
	public ResponseEntity<UserInfo> authenticate(@RequestBody User user)
	{
		log.info("Info received: " + user);
		Optional<User> authUser = userRepo.findOneByEmailAndPassword(user.getEmail(), user.getPassword());
		log.info("Info received from datbase: " + authUser);
		log.info("TEST: " + authUser.isPresent());
		
		if(!authUser.isPresent())
			throw new UserNotFoundException("Invalid credentials");
		
		UserInfo userinfo = new UserInfo();
		userinfo.setEmail(authUser.get().getEmail());
		userinfo.setFirstName(authUser.get().getFirstName());
		
		//return ResponseEntity.ok().build();
		return ResponseEntity.ok(userinfo);
	}
	
	/**
	 * Function for getting the address projections for a person
	 * @param email
	 * @return
	 */
	//TODO Service for updating user details
	@PostMapping("/userDetails/")
	public UserProjection getUserDetails(@RequestBody String email)
	{
		log.info("EMAIL:>>>>>>>>>>>>>>>>>>>>> " + email);
		log.info("Info received: " + userRepo.findOneByEmail(email));
		return userRepo.findOneByEmail(email);
	}
	
	@PostMapping("/updateAddress/")
	public void updateUserAddress(@RequestBody User user)
	{
		log.info("User ::::::::::::::::::  " + user);
		Optional<User> dbUser = userRepo.findById(user.getId());

		if(dbUser.isPresent())
		{
			User temp = dbUser.get();
			temp.setAddressline1(user.getAddressline1());
			temp.setAddressline2(user.getAddressline2());
			temp.setCity(user.getCity());
			temp.setState(user.getState());
			temp.setPin(user.getPin());
			userRepo.save(temp);
			
			log.info("Address updated successfully");
		}
		
		//TODO THROW USER NOT FOUND
		log.info("Info received: " + userRepo.findById(user.getId()));
	}
	
	/**
	 * Function for getting the previous purchase history for a user.
	 * @param userId
	 * @return
	 */
	@PostMapping("/previouspurchase/")
	public List<PurchaseHistory> getPreviousPurchases(@RequestBody int userId)
	{
		log.info("userId:>>>>>>>>>>>>>>>>>>>>> " + userId);
		List<Object[]> previousPurchasesList = userRepo.findPreviousPurchases(userId, 5);
		List<PurchaseHistory> purchasesList = new ArrayList<PurchaseHistory>();
		for(int i = 0; i < previousPurchasesList.size(); i++)
		{
			PurchaseHistory temp = new PurchaseHistory();
			temp.setTitle((String) previousPurchasesList.get(i)[0]);
			temp.setImage((byte[]) previousPurchasesList.get(i)[1]);
			temp.setQuantity((int) previousPurchasesList.get(i)[2]);
			temp.setOrderDate((Date) previousPurchasesList.get(i)[3]);
			
			purchasesList.add(temp);
		}
		
		log.info(purchasesList);
		
		return purchasesList;
	}
	
	@PostMapping("/testMethod/")
	public OrderRequest testMethod()
	{
		OrderRequest test = new OrderRequest();
		test.setUserId(20);
		HashMap<Integer, Integer> testMap = new HashMap<Integer, Integer>();
		testMap.put(1, 5);
		testMap.put(2, 8);
		testMap.put(20, 4);
		testMap.put(15, 1);
		test.setItems(testMap);
		
		log.info(test);
		return test;
	}
	
}