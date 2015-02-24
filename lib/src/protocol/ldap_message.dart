part of ldap_protocol;

/**
 * Envelope for LDAP message protocol exchange
 *
 * See http://tools.ietf.org/html/rfc4511
 *
 *   LDAPMessage ::=
         SEQUENCE {
              messageID      MessageID,
              protocolOp     CHOICE {
                                  bindRequest         BindRequest,
                                  bindResponse        BindResponse,
                                  unbindRequest       UnbindRequest,
                                  searchRequest       SearchRequest,
                                  searchResponse      SearchResponse,
                                  modifyRequest       ModifyRequest,
                                  modifyResponse      ModifyResponse,
                                  addRequest          AddRequest,
                                  addResponse         AddResponse,
                                  delRequest          DelRequest,
                                  delResponse         DelResponse,
                                  modifyRDNRequest    ModifyRDNRequest,
                                  modifyRDNResponse   ModifyRDNResponse,
                                  compareDNRequest    CompareRequest,
                                  compareDNResponse   CompareResponse,
                                  abandonRequest      AbandonRequest
                             }
         }
 *
 *
 */
class LDAPMessage {

  int _messageId;
  int _protocolTag;

  int get protocolTag => _protocolTag;

  ASN1Sequence _protocolOp;
  ASN1Sequence _controls;
  ASN1Sequence _obj;

  /// return the message id sequence number.
  int get messageId => _messageId;

  ASN1Sequence get controls => _controls;

  /// return the [ASN1Sequence] that makes up this LDAP message
  ASN1Sequence get protocolOp => _protocolOp;

  /// the total length of this encoded message in bytes
  int get messageLength => _obj.totalEncodedByteLength;


  LDAPMessage(this._messageId,RequestOp rop,[List<Control> controls = null]) {
    _protocolTag = rop.protocolOpCode;
    _obj = rop.toASN1();
    if( controls != null && controls.length > 0) {
      _controls = new ASN1Sequence(tag:CONTROLS);
      controls.forEach((control) {
        _controls.add( control.toASN1());
        logger.finest("adding control $control");
      });
    }

    String toString() =>
        "LDAPMessage(id=$_messageId $protocolOp controls=$_controls";

  }

  /// Constructs an LDAP message from list of raw bytes.
  /// Bytes will be parsed as an ASN1Sequence
  LDAPMessage.fromBytes(Uint8List bytes) {
    _obj = new ASN1Sequence.fromBytes(bytes);

    checkCondition(_obj !=null,"Parsing error on ${bytes}");
    checkCondition( _obj.elements.length == 2 || _obj.elements.length == 3, "Expecting two or three elements.actual = ${_obj.elements.length} obj=$_obj");

    var i = _obj.elements[0] as ASN1Integer;
    _messageId = i.intValue;

    _protocolOp = _obj.elements[1] as ASN1Sequence;

    _protocolTag = _protocolOp.tag;

    // optional - message has controls....
    if( _obj.elements.length == 3) {
      logger.finest("Controls = ${_obj.elements[2]} ${_obj.elements[2].encodedBytes}");
      // todo: Get rid of this hack
      // See http://stackoverflow.com/questions/15035349/how-does-0-and-3-work-in-asn1

      // todo: figure out how to decode controls properly

      var c = _obj.elements[2].encodedBytes;

      // controls are encoded using "context specific" BER encoding
      // you need to know the specific value to understand how to decode the bytes

      switch( c[0]) {
        case ExtendedResponse.TYPE_EXTENDED_RESPONSE_OID:
          // encoded value is an octet string representing an OID
          var s = new ASN1OctetString(c);
          logger.fine("Got response OID = ${s.stringValue}");

          break;
        case Control.CONTROLS_TAG:
          // control - decode as sequence...
          _controls = new ASN1Sequence.fromBytes(c);
          break;
        default:
          throw new LDAPException("unknown LDAP control. Please fix me");
      }

    }

    logger.fine("Got LDAP Message. Id = ${messageId} protocolOp = ${protocolOp}");

  }


  // Convert this LDAP message to a stream of ASN1 encoded bytes
  List<int> toBytes() {

    //logger.finest("Converting this object to bytes ${toString()}");
    ASN1Sequence seq = new ASN1Sequence();

    seq.add( new ASN1Integer(_messageId));

    seq.add(_obj);
    if( _controls != null)
      seq.add(_controls);

    var b = seq.encodedBytes;

    var xx = LDAPUtil.toHexString(b);
    logger.finest("LdapMesssage bytes = ${xx}");
    return b;

  }

  String toString() {
    var s = _op2String(_protocolTag);
    return "Msg(id=${_messageId}, op=${s},controls=$_controls)";
  }

}
