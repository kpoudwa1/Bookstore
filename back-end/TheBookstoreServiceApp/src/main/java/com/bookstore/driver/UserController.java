package com.bookstore.driver;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.Set;
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
@RequestMapping("/bookstore/users")
public class UserController
{
	@Autowired
	UserRepository userRepo;
	@Autowired
	OrderRepository orderRepo;
	
	private static Logger log = LogManager.getLogger(UserController.class);

	/**
	 * Function for creating a user account.
	 * @param user The details of the new user.
	 * @return Does not return any data.
	 * @exception UserAlreadyExists Throws an exception if the email
	 *  already exists in the system.
	 */
	@PostMapping("/createAccount")
	public ResponseEntity<Void> createUser(@RequestBody User user)
	{
		log.info("Creating a new user account");
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
		log.info("New account created !");
		
		return ResponseEntity.created(null).build();
	}
	
	/**
	 * Function for authenticating an user.
	 * @param user The email id and password.
	 * @return Return the first name and email id of the user.
	 * @exception UserNotFoundException Throws an exception if
	 *  the user does not exists.
	 */
	@PostMapping("/authenticateUser")
	public ResponseEntity<UserInfo> authenticate(@RequestBody User user)
	{
		log.info("Authenticating user: " + user.getEmail());
		
		Optional<User> authUser = userRepo.findOneByEmailAndPassword(user.getEmail(), user.getPassword());
		if(!authUser.isPresent())
		{
			log.info("User does not exists !");
			throw new UserNotFoundException("Invalid credentials");
		}
		
		//Setting the details to be returned
		UserInfo userinfo = new UserInfo();
		userinfo.setEmail(authUser.get().getEmail());
		userinfo.setFirstName(authUser.get().getFirstName());
		log.info("User authenticated");
		
		return ResponseEntity.ok(userinfo);
	}
	
	/**
	 * Function for getting the address details of a user.
	 * @param email The email id for the user.
	 * @return Returns the address details for the user.
	 */
	@PostMapping("/getUserDetails")
	public UserProjection getUserDetails(@RequestBody String email)
	{
		log.info("Getting the address details for " + email);
		return userRepo.findOneByEmail(email);
	}
	
	/**
	 * Function for updating the user address in database.
	 * @param user The address for the user.
	 */
	@PostMapping("/updateUserAddress")
	public void updateUserAddress(@RequestBody User user)
	{
		log.info("Updating the address for  " + user.getEmail());
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
	}
	
	/**
	 * Function for getting the previous purchase history for a user.
	 * @param userId The user id for the user.
	 * @return Returns the purchase history for the user.
	 */
	@PostMapping("/getPreviousPurchases")
	public List<PurchaseHistory> getPreviousPurchases(@RequestBody int userId)
	{
		log.info("Getting the purchase history for " + userId);
		
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
		
		log.info("Purchase history has been retrieved");
		
		return purchasesList;
	}
	
	/**
	 * Function for ordering books.
	 * @param request The details of the order such as book id
	 *  and quantity.
	 */
	@PostMapping("/processOrder")
	public void processOrder(@RequestBody OrderRequest request)
	{
		log.info("Processing order for " + request.getEmail());
		
		Optional<User> user = userRepo.findIdByEmail(request.getEmail());
		int userId = user.get().getId();

		Set<Integer> keys = request.getItems().keySet();
		Iterator<Integer> iter = keys.iterator();
		while(iter.hasNext())
		{
			int bookId = iter.next();
			
			Order item = new Order();
			item.setUserId(userId);
			item.setBookId(bookId);
			item.setQuantity(request.getItems().get(bookId));
			item.setStatus(1);
			item.setStatusDate(new Date());
			
			orderRepo.save(item);
		}
		
		log.info("Order saved successfully");
	}
	
	/**
	 * Function for tracking pending orders.
	 * @param email The email id of the user.
	 * @return A list of pending orders for the user.
	 */
	@PostMapping("/trackOrders")
	public List<TrackOrder> trackOrder(@RequestBody String email)
	{
		log.info("Tracking orders for " + email);
		
		Optional<User> user = userRepo.findIdByEmail(email);
		int userId = user.get().getId();

		List<TrackOrder> ordersList = new ArrayList<TrackOrder>();
		List<Object[]> orders = userRepo.findOrders(userId, 5);
		
		for(int i = 0; i < orders.size(); i++)
		{
			TrackOrder temp = new TrackOrder();
			temp.setBookId((int) orders.get(i)[0]);
			temp.setImage((byte[]) orders.get(i)[1]);
			temp.setStatus((String) orders.get(i)[2]);
			temp.setStatusDate((Date) orders.get(i)[3]);
			
			ordersList.add(temp);
		}
		
		log.info("Orders have been tracked");
		
		return ordersList;
	}
}