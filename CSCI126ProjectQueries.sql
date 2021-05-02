CREATE TABLE recipe_reagents(Spell_ID int, Item_ID int, Quantity int, PRIMARY KEY (Spell_ID, Item_ID));
CREATE TABLE recipes(Spell_ID int Primary Key, Item_ID int);
CREATE TABLE items(Item_ID int Primary Key, Item_Description varchar(255), Vendor_Purchase int, Vendor_Sell int);
CREATE TABLE market(Realm_ID int REFERENCES realms(Realm_ID), Item_ID int, Price int, Quantity int, PRIMARY KEY (Realm_ID, Item_ID));
CREATE TABLE realms(Realm_ID int PRIMARY KEY, Realm_Name varchar(255), Region char(2), Locale char(5), Population int);

/*Example Queries*/
/*Subquery - Compares Cost to Buy vs Cost to Create Items*/
SELECT items.item_description as "Product", 
    market.Price/10 as "Product Price",
    sum(reagentPrice.price*recipe_reagents.quantity)/10 as "Reagents Sum Cost"
    FROM items, 
    recipes, 
    recipe_reagents, 
    market, 
    market as reagentPrice
    where recipes.Spell_ID=recipe_reagents.spell_id 
    and recipes.item_id=items.Item_ID 
    and market.Item_ID=recipes.item_id
    and reagentPrice.item_id=recipe_reagents.Item_ID
    and market.Realm_ID=2
    GROUP BY recipes.item_id;
    
/*Aggregate - Compares Cost of item for single realm vs average cost across all realms*/
SELECT A.Item_ID, A.Realm_ID, A.Price as Price, avg(B.Price) as Average_Price
FROM market as A
CROSS JOIN market AS B 
WHERE A.Item_ID = 2303 
AND A.item_id=B.item_id
GROUP BY
    A.Item_ID,
    A.Price
HAVING A.Price <= avg(B.Price)
ORDER BY A.Realm_ID


/*Insert - 2 insertion queries: first adds a new realm, and 2nd adds a new market list with that realm as
an attribute*/
INSERT INTO realms(Realm_ID, Realm_Name, Region, Locale, Population)
VALUES(434, "Cali", "US", "en_US", 155000);
INSERT INTO market(Realm_ID, Item_ID, Price, Quantity)
VALUES(434, 5000, 1000000, 20);

/*Update - Inserts a tuple, then updates its price based on its quantity attribute*/
INSERT INTO market(Realm_ID, Item_ID, Price, Quantity) VALUES(434, 4267, 1000, 1);
UPDATE market SET Price = 100000000 
WHERE market.Quantity=1 and Realm_ID=434;
SELECT market.Realm_ID, Item_ID, Price, Quantity
FROM market
WHERE market.Realm_ID=434;
