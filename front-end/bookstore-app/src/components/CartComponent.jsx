import React, { Component } from 'react';
import Logo from '../logo-white.png';
import { Formik, Form, Field, ErrorMessage } from 'formik';
import {Link} from 'react-router-dom';
import UserAPI from '../api/UserAPI.js';
import SearchAPI from '../api/SearchAPI.js';

class CartComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			cartItems : []
		}
		this.buyItems = this.buyItems.bind(this)
		
		this.createAccount = this.createAccount.bind(this)
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
		this.validate = this.validate.bind(this)
	}
	
  render() {
	let { cartItems } = this.state
    return (
      <div className="CartComponent">
	  <h1>Simple Cart</h1>
	  <hr style={hrStyle}/>
	  <center>
		<table style={tableStyle} className="table">
			<thead>
				<tr>
					<th>Item</th>
					<th>Quantity</th>
				</tr>
			</thead>
			<tbody>
				{
					this.state.cartItems.map(cartItem => 
							<tr key={cartItem.id}>
								<td style={imageWidth}><img width="70px" src={'data:image/jpeg;base64,' + cartItem.image}/></td>
								<td>{cartItem.quantity}</td>
							</tr>
					)
				}
			</tbody>
		</table>
		
		<Formik
                    initialValues={{ cartItems }}
                    onSubmit={this.buyItems}
                    validateOnChange={false}
                    enableReinitialize={true}
                >
                    {
                        (props) => (
                            <Form>
                                <button className="btn btn-success" type="submit">Buy</button>
                            </Form>
                        )
                    }
                </Formik>
	  </center>
      </div>
    );
  }
  
  async componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	let arr = await UserAPI.displayCart()
	console.log('ARRAY:::::::: ' + arr);
	let cartItems = [];
	this.setState({
		  cartItems: arr
	  })
	/*for (var i = 0; i < arr.length; i++) {
		let quantity = sessionStorage.getItem(arr[i]);
        console.log('AAAAAAAAAAAAAAAAAAAAAAA' + arr[i] + ' :: ' + sessionStorage.getItem(arr[i]));
		let cartItem = SearchAPI.executeSearchByIdAPIService(arr[i])
		.then(response => this.handleSuccessfulResponse(response, quantity))
		.catch(error => this.handleErrorResponse(error))
		
		console.log('CART ITEM IN LOOP: ' + JSON.stringify(cartItem));
    }*/
	//.then(response => this.handleSuccessfulResponse(response))
	//.catch(error => this.handleErrorResponse(error))
  }
  
  buyItems(values)
  {
	  console.log('Buy Items !!!!!!!!!!');
	  console.log(values);
	  
	  //let email = UserAPI.getEmail();
	  let cartDetails  = new Object();
	  
	  for (var i = 0; i < values.cartItems.length; i++) {
		  console.log(values.cartItems[i].id);
		let bookId = values.cartItems[i].id;
		let quantity = values.cartItems[i].quantity;
		cartDetails[`${bookId}`] = quantity;
    }
	console.log('Buy Items !!!!!!!!!!');
	console.log(cartDetails);
	let orderRequest = {};
	orderRequest.email = UserAPI.getEmail();
	orderRequest.items = cartDetails;
	console.log(orderRequest);
	UserAPI.executeProcessOrderAPIService(orderRequest)
		.then(response => this.handleSuccessfulResponse(response, values))
	    .catch(error => this.handleErrorResponse(error))
  }
  
  validate(values)
  {
	  console.log(values)
	  let errors = {};
	  let message = 'This field is mandatory';
	  
	  if(!values.email)
		  errors.email = message;
	  if(!values.password)
		  errors.password = message;
	  
	  return errors;
  }
  
  createAccount()
  {
	  console.log('Create a new account');
	  console.log(this.state);
	  this.props.history.push("/createAccount")
	  console.log(this.state);
  }
  
  handleSuccessfulResponse(response, quantity)
  {
	  console.log('Success');
	  //console.log('Cart item' + quantity);
	  //console.log(response.data);
	  //let cartItem = {
		//  image: response.data.image,
		  //quantity: quantity
	  //}
	  
	  //return cartItem;
	  //console.log('Single item' + JSON.stringify(cartItem));
  }
  
  handleErrorResponse(error)
  {
	  if(error.response.status === 404)
		error.response.status = error.response.status + ' Not found';

	  this.setState({
			loginFailed : true,
			loginSuccess : false
		})
  }
}

const hrStyle = {
  border: 'none',
    height: '1px',
    color: '#333',
    backgroundColor: '#333'
};

var tableStyle = 
{
	width: '50%'
}

var imageWidth =
{
	width: '70px',
	paddingLeft: '15px'
}
export default CartComponent;