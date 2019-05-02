import axios from 'axios'
import SearchAPI from '../api/SearchAPI.js';
var crypto = require('crypto'); 

class UserAPI
{
	registerLogin(firstName, email)
	{
		console.log('###################################################################################');
		sessionStorage.setItem('authenicatedUser', firstName);
		sessionStorage.setItem('authenicatedEmail', email);
	}
	
	registerLogout()
	{
		sessionStorage.removeItem('authenicatedUser');
		sessionStorage.removeItem('cart');
		sessionStorage.clear();
	}
	
	isUserLoggedIn()
	{
		let user = sessionStorage.getItem('authenicatedUser');
		
		if(user === null)
			return false
		else
			return true
	}
	
	addItem(itemId, quantity)
	{
		sessionStorage.setItem(itemId, quantity);
	}
	
	getUserName()
	{
		return sessionStorage.getItem('authenicatedUser');
	}
	
	async displayCart()
	{
		console.log('Getting the cart details');
		let arr = Object.keys(sessionStorage);
		console.log(arr)
		let index = arr.indexOf('authenicatedUser');
		console.log('INDEX: ' + index);
		if (index > -1)
		{
			arr.splice(index, 1);
		}
		console.log(arr)
		
		console.log('loop IN USER API');
		let cartItems = [];
		
		
		for (var i = 0; i < arr.length; i++) {
		let quantity = sessionStorage.getItem(arr[i]);
        console.log('AAAAAAAAAAAAAAAAAAAAAAA' + arr[i] + ' :: ' + sessionStorage.getItem(arr[i]));
		let dbData = await SearchAPI.executeSearchByIdAPIService(arr[i])
		
		let cartItem = {
		  id: dbData.data.id,
		  image: dbData.data.image,
		  quantity: quantity
	  }
		
		cartItems.push(cartItem);
		//console.log('CART ITEM IN LOOP: ' + JSON.stringify(cartItem));
    }
		//console.log('CART ITEM IN LOOP: ' + JSON.stringify(cartItems));
		
		
		
		
		return cartItems;
	}
	
	executeCreateUserAPIService(stateData)
	{
		console.log('Service executed')
		let salt = crypto.randomBytes(16).toString('hex'); 
		console.log('Salt: ' + salt);
		console.log(stateData)
		stateData.salt = salt;
		console.log(stateData)
		stateData.password = crypto.pbkdf2Sync(stateData.password, stateData.email, 1000, 64, `sha512`).toString(`hex`)
		console.log(crypto.pbkdf2Sync(stateData.password, stateData.email, 1000, 64, `sha512`).toString(`hex`))
		
		
		console.log(stateData)
		return axios.post(`http://localhost:8080/user/create/`, stateData)
	}
	
	executeAuthenticateUserAPIService(user)
	{
		console.log('executeAuthenticateUserAPIService')
		console.log(user)
		user.password = crypto.pbkdf2Sync(user.password, user.email, 1000, 64, `sha512`).toString(`hex`)
		console.log(user)
		
		return axios.post(`http://localhost:8080/user/authenticate/`, user)
	}
	
	executeGetUserDetailsAPIService(email)
	{
		console.log('executeGetUserDetailsAPIService')
		console.log(email)
		let data = {email : email}
		
		console.log(data);
		let axiosConfig = {
		headers: {
          'Content-Type': 'application/json;charset=UTF-8'
      }
    };
		
		return axios.post(`http://localhost:8080/user/userDetails/`, email, axiosConfig)
	}
	
	executeGetPreviousPurchasesAPIService(userId)
	{
		console.log('executeGetPreviousPurchasesAPIService');
		console.log(userId);
		let axiosConfig = {
		headers: {
          'Content-Type': 'application/json;charset=UTF-8'
      }
    };
		
		return axios.post(`http://localhost:8080/user/previouspurchase/`, userId, axiosConfig)
	}
	
	executeupdateAddressAPIService(user)
	{
		console.log('executeupdateAddressAPIService')
		console.log(user)
		
		return axios.post(`http://localhost:8080/user/updateAddress/`, user)
	}
}

export default new UserAPI();