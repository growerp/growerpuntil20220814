# GrowERP releases


## June 1, 2022 beta release (last beta?) 

1. Automatically generated [e-commerce website](../end_user/marketing_sales.md)
	- Maintenance from flutter frontend:
		- logo, products and categories
		- title, about, support, using markdown format
	- using improved demo data
	- multi currency
	- multi company
	- selenium tests

2. [Api documented and available](technical_user/api.md) for testing with Flutter frontend
	- in/output parameters definition
	- authorization
	- test/production sites at test.growerp.org/backend.growerp.com

3. [Stripe payment gateway](technical_user/stripe.md).
	- working with E-commerce website and flutter frontend.

4. Flutter frontend improvements:
	- Added E-commerce website maintenance to flutter frontend at company -> website
	- adding categories to products and adding products to categories improved
	- no mandatory assignment of a product to at least a single category
	- be able to add assets at the product screen
	- improved demo data from Moqui PopRestStore
	- integration tests now all fixed.
	- A product can now be assigned to more categories
	- Upgraded to flutter v3 with mostly latest packages.
	- upgraded app in app/play store

## Second beta release May 3, 2022

1. Input of invoice/payment without an order with automatic posting.
2. better integration tests.
3. more confirmation messages.
4. first Stripe implementation.
5. Invoice and payment creation without Order
6. Started documentation in docsify package

## First beta release feb 28, 2022

Changes since September 2021:

1. All packages now in a single git branch.
2. Reorganized the project into a domain organization see: packages/core/lib/domains
3. Well organized integration tests for all functions.
4. Added a warehouse function: locations, incoming/outgoing shipments.
5. Accounting now working for purchase/sales orders and inventory changes.
6. Improved models, backend API and adding 'freeze' and 'jsonserializer' (need to run buildrunner on core package)
7. Introduction of smart enum classes (FinDocType,FinDocStatusVal)
8. Upgraded to bloc V8, flutter 2.16
9. Merged login/change password bloc into Authenticate bloc.
10. Started new app: freelance

