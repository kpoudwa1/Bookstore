import axios from 'axios'
import SearchAPI from '../api/SearchAPI.js';
import { API_URL } from '../Constants'
export const USER_SESSION_EMAIL = 'authenicatedEmail'
export const USER_SESSION_FIRST_NAME = 'authenicatedUser'

var crypto = require('crypto');

class UserAPI
{
	registerLogin(firstName, email)
	{
		console.log('###################################################################################');
		sessionStorage.setItem(USER_SESSION_FIRST_NAME, firstName);
		sessionStorage.setItem(USER_SESSION_EMAIL, email);
	}
	
	registerLogout()
	{
		sessionStorage.removeItem(USER_SESSION_FIRST_NAME);
		sessionStorage.removeItem('cart');
		sessionStorage.clear();
	}
	
	isUserLoggedIn()
	{
		let user = sessionStorage.getItem(USER_SESSION_FIRST_NAME);
		
		if(user  === null)
			return false
		return true
		
		/*if(user === null)
			return false
		else
			return true*/
	}
	
	addItem(itemId, quantity)
	{
		sessionStorage.setItem(itemId, quantity);
	}
	
	getUserName()
	{
		return sessionStorage.getItem(USER_SESSION_FIRST_NAME);
	}
	
	getEmail()
	{
		return sessionStorage.getItem(USER_SESSION_EMAIL);
	}
	
	emptyCart()
	{
		let arr = Object.keys(sessionStorage);
		
		let index = arr.indexOf(USER_SESSION_FIRST_NAME);
		if (index > -1)
			arr.splice(index, 1);
		
		index = arr.indexOf(USER_SESSION_EMAIL);
		if (index > -1)
			arr.splice(index, 1);
		
		for(var i = 0; i < arr.length; i++)
			sessionStorage.removeItem(arr[i]);
	}
	
	async displayCart()
	{
		console.log('Getting the cart details');
		let arr = Object.keys(sessionStorage);
		console.log(arr)
		let index = arr.indexOf(USER_SESSION_FIRST_NAME);
		console.log('INDEX: ' + index);
		if (index > -1)
		{
			arr.splice(index, 1);
		}
		index = arr.indexOf(USER_SESSION_EMAIL);
		if (index > -1)
		{
			arr.splice(index, 1);
		}
		
		
		console.log(arr)
		
		console.log('loop IN USER API');
		let cartItems = [];
		
		
		for(var i = 0; i < arr.length; i++) {
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
		return axios.post(`${API_URL}/bookstore/users/createAccount`, stateData)
	}
	
	executeAuthenticateUserAPIService(user)
	{
		console.log('executeAuthenticateUserAPIService')
		console.log(user)
		user.password = crypto.pbkdf2Sync(user.password, user.email, 1000, 64, `sha512`).toString(`hex`)
		console.log(user)
		
		return axios.post(`${API_URL}/bookstore/users/authenticateUser`, user)
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
		
		return axios.post(`${API_URL}/bookstore/users/getUserDetails`, email, axiosConfig)
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
		
		return axios.post(`${API_URL}/bookstore/users/getPreviousPurchases`, userId, axiosConfig)
	}
	
	executeProcessOrderAPIService(orderDetails)
	{
		console.log('executeProcessOrderAPIService')
		console.log(orderDetails)
		
		return axios.post(`${API_URL}/bookstore/users/processOrder`, orderDetails)
	}
	
	executeTrackOrderAPIService()
	{
		console.log('executeProcessOrderAPIService')
		console.log(sessionStorage.getItem(USER_SESSION_EMAIL))
		let axiosConfig = {
		headers: {
          'Content-Type': 'application/json;charset=UTF-8'
      }
    };
		
		return axios.post(`${API_URL}/bookstore/users/trackOrders`, sessionStorage.getItem(USER_SESSION_EMAIL), axiosConfig)
	}
	
	executeupdateAddressAPIService(user)
	{
		console.log('executeupdateAddressAPIService')
		console.log(user)
		
		return axios.post(`${API_URL}/bookstore/users/updateUserAddress`, user)
	}
}

export default new UserAPI();