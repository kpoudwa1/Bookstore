import React, { Component } from 'react';
import { Formik, Form} from 'formik';
import UserAPI from '../api/UserAPI.js';

class CartComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			cartItems : [],
			isCartEmpty : false,
			isOrderPlaced : false
		}
		this.buyItems = this.buyItems.bind(this)
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
		this.validate = this.validate.bind(this)
	}
	
  render() {
	let { cartItems } = this.state
    return (
      <div className="CartComponent">
		<h2>Cart contents...</h2>
		{this.state.isCartEmpty && <div><br/><font className="alert alert-primary">Cart is empty !</font><br/><br/></div>}
		{this.state.isOrderPlaced && <div><br/><font className="alert alert-success">Your order has been placed !</font><br/><br/></div>}
		{!this.state.isCartEmpty && <div>
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
								<td style={imageWidth}><img alt={cartItem.id} width="100px" src={'data:image/jpeg;base64,' + cartItem.image}/></td>
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
		</div>}
      </div>
    );
  }
  
  async componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	let arr = await UserAPI.displayCart()
	console.log('ARRAY:::::::: ' + arr);
	console.log('ARRAY:::::::: ' + arr.length);
	
	this.setState({
		  cartItems: arr
	  })
	  
	if(arr.length === 0)
	{
		this.setState({
		  isCartEmpty: true
	  })
	}
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
	  let cartDetails  = {};
	  //new Object();
	  
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
  
  handleSuccessfulResponse(response, quantity)
  {
	  console.log('Success');
	  UserAPI.emptyCart();
	  this.setState({
		  cartItems: [],
		  isOrderPlaced: true
	  })

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