package com.bookstore.driver;

import java.util.Calendar;
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
	public ResponseEntity<Void> authenticate(@RequestBody User user)
	{
		log.info("Info received: " + user);
		Optional<User> authUser = userRepo.findOneByEmailAndPassword(user.getEmail(), user.getPassword());
		log.info("Info received from datbase: " + authUser);
		log.info("TEST: " + authUser.isPresent());
		
		if(!authUser.isPresent())
			throw new UserNotFoundException("Invalid credentials");
		
		return ResponseEntity.ok().build();
	}
}