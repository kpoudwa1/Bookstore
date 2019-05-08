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
	let arr = await UserAPI.displayCart()
	
	this.setState({ cartItems: arr })
	  
	if(arr.length === 0)
	{
		this.setState({ isCartEmpty: true })
	}
  }
  
  buyItems(values)
  {
	  let cartDetails  = {};//new Object();
	  
	  for (var i = 0; i < values.cartItems.length; i++) {
		let bookId = values.cartItems[i].id;
		let quantity = values.cartItems[i].quantity;
		cartDetails[`${bookId}`] = quantity;
    }
	
	let orderRequest = {};
	orderRequest.email = UserAPI.getEmail();
	orderRequest.items = cartDetails;

	UserAPI.executeProcessOrderAPIService(orderRequest)
		.then(response => this.handleSuccessfulResponse(response, values))
	    .catch(error => this.handleErrorResponse(error))
  }
  
  validate(values)
  {
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
	  UserAPI.emptyCart();
	  this.setState({
		  cartItems: [],
		  isOrderPlaced: true
	  })
  }
  
  handleErrorResponse(error)
  {
	  if(!error.response)
		  this.props.history.push({ pathname: '/error' })
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