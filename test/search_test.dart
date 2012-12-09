

import 'package:unittest/unittest.dart';


import 'package:dartdap/ldap_client.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:scalarlist';
import 'dart:math';
import 'dart:isolate';


main() {
  //var dn = "cn=test";
  var dn = "cn=Directory Manager";
  var pw = "password";


  initLogging();



 test('Search Test', () {
   var attrs = ["dn", "cn", "objectClass"];

   var c = new LDAPConnection("localhost", 1389,dn,pw);

   c.onError = expectAsync1((e) => expect(false, 'Should not be reached'), count: 0);

   var fb  = c.bind();

   fb.then( (r) { print("Bind happend"); });

   var filter = new SubstringFilter("cn=A*");


   var sb = c.search("dc=example,dc=com", filter, attrs);


   sb.then( expectAsync1( (SearchResult r) {
         print("Search Completed r = ${r}");
       }, count: 1));

  c.close();

 });


 test("LDAP Filter composition ", () {

   var f1 = new SubstringFilter("cn=foo*");
   expect(f1.any, isEmpty );
   expect(f1.initial.stringValue, equals("foo"));
   expect(f1.finalStr,isNull);


   var f2 = new SubstringFilter("cn=*bar");
   expect(f2.initial,isNull);
   expect(f2.any,isEmpty);
   expect(f2.finalStr.stringValue, equals("bar"));



   var c1 =  f1 & f2;

   print(c1.toString());


 });


}
