package com.bookstore.driver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages={"com.bookstore"})
public class TheBookstoreServiceAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(TheBookstoreServiceAppApplication.class, args);
	}

}
