part of dartdap;

/**
 * Various ldap result objects
 */

/**
* LDAPResult - Sequence
 *   resultCode (ENUM), matchedDN, errorMessage, referral (optional)
 *
 *
 *   Result Code
 *
 *
 *                           success                      (0),
                             operationsError              (1),
                             protocolError                (2),
                             timeLimitExceeded            (3),
                             sizeLimitExceeded            (4),
                             compareFalse                 (5),
                             compareTrue                  (6),

                             authMethodNotSupported       (7),
                             strongAuthRequired           (8),
                                        -- 9 reserved --
                             referral                     (10),  -- new
                             adminLimitExceeded           (11),  -- new
                             unavailableCriticalExtension (12),  -- new
                             confidentialityRequired      (13),  -- new
                             saslBindInProgress           (14),  -- new
                             noSuchAttribute              (16),
                             undefinedAttributeType       (17),
                             inappropriateMatching        (18),
                             constraintViolation          (19),
                             attributeOrValueExists       (20),
                             invalidAttributeSyntax       (21),
                                        -- 22-31 unused --
                             noSuchObject                 (32),
                             aliasProblem                 (33),
                             invalidDNSyntax              (34),
                             -- 35 reserved for undefined isLeaf --
                             aliasDereferencingProblem    (36),
                                        -- 37-47 unused --
                             inappropriateAuthentication  (48),
                             invalidCredentials           (49),
                             insufficientAccessRights     (50),
                             busy                         (51),
                             unavailable                  (52),
                             unwillingToPerform           (53),
                             loopDetect                   (54),
                                        -- 55-63 unused --
                             namingViolation              (64),
                             objectClassViolation         (65),
                             notAllowedOnNonLeaf          (66),
                             notAllowedOnRDN              (67),
                             entryAlreadyExists           (68),
                             objectClassModsProhibited    (69),
                                        -- 70 reserved for CLDAP --
                             affectsMultipleDSAs          (71), -- new
                                        -- 72-79 unused --
                             other                        (80) },
                             -- 81-90 reserved for APIs --
                matchedDN       LDAPDN,
                errorMessage    LDAPString,
                referral        [3] Referral OPTIONAL }
 *
 *
 */

//===============================================================
/**
 * Generic LDAP Result
 */

class LdapResult {
  int _resultCode;
  String _diagnosticMessage;
  String _matchedDN;
  List<String> _referralURLs;

  int get resultCode => _resultCode;
  String get diagnosticMessage => _diagnosticMessage;
  String get matchedDN => _matchedDN;
  List<String> get referralURLs => _referralURLs;

  /// Constructor

  LdapResult(this._resultCode, this._matchedDN, this._diagnosticMessage,
      this._referralURLs) {}

  String toString() =>
      ResultCode.message(_resultCode) +
      ((_diagnosticMessage != null && _diagnosticMessage.isNotEmpty)
          ? ": $_diagnosticMessage"
          : "") +
      ((_matchedDN != null && _matchedDN.isNotEmpty) ? ": $_matchedDN" : "");


  /// Converts an LdapResult whose result code is an error into an exception.
  ///
  /// If the result code does not indicate an exception, null is returned.
  ///
  LdapException exceptionFromResultCode() {

    switch (resultCode) {
      case ResultCode.OPERATIONS_ERROR:
        return new LdapResultOperationsErrorException(this);
        break;

      case ResultCode.PROTOCOL_ERROR:
        return new LdapResultProtocolErrorException(this);
        break;

      case ResultCode.TIME_LIMIT_EXCEEDED:
        return new LdapResultTimeLimitExceededException(this);
        break;

      case ResultCode.SIZE_LIMIT_EXCEEDED:
        return new LdapResultSizeLimitExceededException(this);
        break;

      case ResultCode.AUTH_METHOD_NOT_SUPPORTED:
        return new LdapResultAuthMethodNotSupportedException(this);
        break;

      case ResultCode.STRONG_AUTH_REQUIRED:
        return new LdapResultStrongAuthRequiredException(this);
        break;

      case ResultCode.REFERRAL:
        return new LdapResultReferralException(this);
        break;

      case ResultCode.ADMIN_LIMIT_EXCEEDED:
        return new LdapResultAdminLimitExceededException(this);
        break;

      case ResultCode.UNAVAILABLE_CRITICAL_EXTENSION:
        return new LdapResultUnavailableCriticalExtensionException(this);
        break;

      case ResultCode.CONFIDENTIALITY_REQUIRED:
        return new LdapResultConfidentialityRequiredException(this);
        break;

      case ResultCode.SASL_BIND_IN_PROGRESS:
        return new LdapResultSaslBindInProgressException(this);
        break;

      case ResultCode.NO_SUCH_ATTRIBUTE:
        return new LdapResultNoSuchAttributeException(this);
        break;

      case ResultCode.UNDEFINED_ATTRIBUTE_TYPE:
        return new LdapResultUndefinedAttributeTypeException(this);
        break;

      case ResultCode.INAPPROPRIATE_MATCHING:
        return new LdapResultInappropriateMatchingException(this);
        break;

      case ResultCode.CONSTRAINT_VIOLATION:
        return new LdapResultConstraintViolationException(this);
        break;

      case ResultCode.ATTRIBUTE_OR_VALUE_EXISTS:
        return new LdapResultAttributeOrValueExistsException(this);
        break;

      case ResultCode.INVALID_ATTRIBUTE_SYNTAX:
        return new LdapResultInvalidAttributeSyntaxException(this);
        break;

      case ResultCode.NO_SUCH_OBJECT:
        return new LdapResultNoSuchObjectException(this);
        break;

      case ResultCode.ALIAS_PROBLEM:
        return new LdapResultAliasProblemException(this);
        break;

      case ResultCode.INVALID_DN_SYNTAX:
        return new LdapResultInvalidDnSyntaxException(this);
        break;

      case ResultCode.IS_LEAF:
        return new LdapResultIsLeafException(this);
        break;

      case ResultCode.ALIAS_DEREFERENCING_PROBLEM:
        return new LdapResultAliasDereferencingProblemException(this);
        break;

      case ResultCode.INAPPROPRIATE_AUTHENTICATION:
        return new LdapResultInappropriateAuthenticationException(this);
        break;

      case ResultCode.INVALID_CREDENTIALS:
        return new LdapResultInvalidCredentialsException(this);
        break;

      case ResultCode.INSUFFICIENT_ACCESS_RIGHTS:
        return new LdapResultInsufficientAccessRightsException(this);
        break;

      case ResultCode.BUSY:
        return new LdapResultBusyException(this);
        break;

      case ResultCode.UNAVAILABLE:
        return new LdapResultUnavailableException(this);
        break;

      case ResultCode.UNWILLING_TO_PERFORM:
        return new LdapResultUnwillingToPerformException(this);
        break;

      case ResultCode.LOOP_DETECT:
        return new LdapResultLoopDetectException(this);
        break;

      case ResultCode.NAMING_VIOLATION:
        return new LdapResultNamingViolationException(this);
        break;

      case ResultCode.OBJECT_CLASS_VIOLATION:
        return new LdapResultObjectClassViolationException(this);
        break;

      case ResultCode.NOT_ALLOWED_ON_NONLEAF:
        return new LdapResultNotAllowedOnNonleafException(this);
        break;

      case ResultCode.NOT_ALLOWED_ON_RDN:
        return new LdapResultNotAllowedOnRdnException(this);
        break;

      case ResultCode.ENTRY_ALREADY_EXISTS:
        return new LdapResultEntryAlreadyExistsException(this);
        break;

      case ResultCode.OBJECT_CLASS_MODS_PROHIBITED:
        return new LdapResultObjectClassModsProhibitedException(this);
        break;

      case ResultCode.AFFECTS_MULTIPLE_DSAS:
        return new LdapResultAffectsMultipleDsasException(this);
        break;

      case ResultCode.OTHER:
        return new LdapResultOtherException(this);
        break;

      default:
        assert(resultCode != ResultCode.OK);
        assert(resultCode != ResultCode.COMPARE_FALSE);
        assert(resultCode != ResultCode.COMPARE_TRUE);
        return new LdapResultUnknownCodeException(this);
        break;
    }
  }
}

//===============================================================
/// Search entry result produced by the search operation.
///
/// The [LdapConnection.search] method produces a [SearchResult] which
/// contains a stream of these objects: each representing an entry that matched
/// the search request.
///
/// Use the [dn] propperty to get the entry's distinguished name and the
/// [attributes] properties to get the attributes which were returned.

class SearchEntry {

  /// The entry's distinguished name.

  String get dn => _dn;
  String _dn;

  /// Attributes returned by the search operation.
  ///
  /// This is a [Map] from the [String] name of the attribute to an [Attribute]
  /// object.

  Map<String, Attribute> get attributes => _attributes;
  Map<String, Attribute> _attributes = new Map<String, Attribute>();

  /// Constructor

  SearchEntry(this._dn);

  String toString() => "Entry[$_dn,$_attributes]";
}

//===============================================================
/**
 * LDAP Result Codes
 */
class ResultCode {
  static const int OK = 0;
  static const int OPERATIONS_ERROR = 1;
  static const int PROTOCOL_ERROR = 2;
  static const int TIME_LIMIT_EXCEEDED = 3;
  static const int SIZE_LIMIT_EXCEEDED = 4;
  static const int COMPARE_FALSE = 5;
  static const int COMPARE_TRUE = 6;
  static const int AUTH_METHOD_NOT_SUPPORTED = 7;
  static const int STRONG_AUTH_REQUIRED = 8;
  static const int REFERRAL = 9;
  static const int ADMIN_LIMIT_EXCEEDED = 11;
  static const int UNAVAILABLE_CRITICAL_EXTENSION = 12;
  static const int CONFIDENTIALITY_REQUIRED = 13;
  static const int SASL_BIND_IN_PROGRESS = 14;
  static const int NO_SUCH_ATTRIBUTE = 16;
  static const int UNDEFINED_ATTRIBUTE_TYPE = 17;
  static const int INAPPROPRIATE_MATCHING = 18;
  static const int CONSTRAINT_VIOLATION = 19;
  static const int ATTRIBUTE_OR_VALUE_EXISTS = 20;
  static const int INVALID_ATTRIBUTE_SYNTAX = 21;
  static const int NO_SUCH_OBJECT = 32;
  static const int ALIAS_PROBLEM = 33;
  static const int INVALID_DN_SYNTAX = 34;
  static const int IS_LEAF = 35;
  static const int ALIAS_DEREFERENCING_PROBLEM = 36;
  static const int INAPPROPRIATE_AUTHENTICATION = 48;
  static const int INVALID_CREDENTIALS = 49;
  static const int INSUFFICIENT_ACCESS_RIGHTS = 50;
  static const int BUSY = 51;
  static const int UNAVAILABLE = 52;
  static const int UNWILLING_TO_PERFORM = 53;
  static const int LOOP_DETECT = 54;
  static const int NAMING_VIOLATION = 64;
  static const int OBJECT_CLASS_VIOLATION = 65;
  static const int NOT_ALLOWED_ON_NONLEAF = 66;
  static const int NOT_ALLOWED_ON_RDN = 67;
  static const int ENTRY_ALREADY_EXISTS = 68;
  static const int OBJECT_CLASS_MODS_PROHIBITED = 69;
  static const int AFFECTS_MULTIPLE_DSAS = 71;
  static const int OTHER = 80;

  // Important: do not add constants without also adding a message for it below,
  // creating a unique exception for it, and throwing that exception in
  // [_FuturePendingOp.processResult]

  static final Map<int, String> _messages = {
    OK: "OK",
    OPERATIONS_ERROR: "Operations error",
    PROTOCOL_ERROR: "Protocol error",
    TIME_LIMIT_EXCEEDED: "Time limit exceeded",
    SIZE_LIMIT_EXCEEDED: "Size limit exceeded",
    COMPARE_FALSE: "Compare false",
    COMPARE_TRUE: "Compare true",
    AUTH_METHOD_NOT_SUPPORTED: "Auth method not supported",
    STRONG_AUTH_REQUIRED: "Strong auth required",
    REFERRAL: "Referral",
    ADMIN_LIMIT_EXCEEDED: "Admin limit exceeded",
    UNAVAILABLE_CRITICAL_EXTENSION: "Unavailable critical extension",
    CONFIDENTIALITY_REQUIRED: "Confidentiality required",
    SASL_BIND_IN_PROGRESS: "SASL bind in progress",
    NO_SUCH_ATTRIBUTE: "No such attribute",
    UNDEFINED_ATTRIBUTE_TYPE: "Undefined attribute type",
    INAPPROPRIATE_MATCHING: "Inappropriate matching",
    CONSTRAINT_VIOLATION: "Constraint violation",
    ATTRIBUTE_OR_VALUE_EXISTS: "Attribute or value exists",
    INVALID_ATTRIBUTE_SYNTAX: "Invalid attribute syntax",
    NO_SUCH_OBJECT: "No such object",
    ALIAS_PROBLEM: "Alias problem",
    INVALID_DN_SYNTAX: "Invalid DN syntax",
    IS_LEAF: "Is leaf",
    ALIAS_DEREFERENCING_PROBLEM: "Alias dereferencing problem",
    INAPPROPRIATE_AUTHENTICATION: "Inappropriate authentication",
    INVALID_CREDENTIALS: "Invalid credentials",
    INSUFFICIENT_ACCESS_RIGHTS: "Insufficient access rights",
    BUSY: "Busy",
    UNAVAILABLE: "Unavailable",
    UNWILLING_TO_PERFORM: "Unwilling to perform",
    LOOP_DETECT: "Loop detect",
    NAMING_VIOLATION: "Naming violation",
    OBJECT_CLASS_VIOLATION: "Object class violation",
    NOT_ALLOWED_ON_NONLEAF: "Not allowed on nonleaf",
    NOT_ALLOWED_ON_RDN: "Not allowed on RDN",
    ENTRY_ALREADY_EXISTS: "Entry already exists",
    OBJECT_CLASS_MODS_PROHIBITED: "Object class mods prohibited",
    AFFECTS_MULTIPLE_DSAS: "Affects multiple DSAS",
    OTHER: "Other"
  };

  /// Returns a human readable string describing the result [code].

  static String message(int code) =>
      _messages[code] ?? "LDAP result code $code";

  //===============================================================

  /// The integer value of the result code.

  int _value;

  /// Constructor from an integer value.

  ResultCode(this._value) {}

  /// The equality operator
  ///
  /// Returns true if and only if the [value] of the two are the same.

  bool operator ==(ResultCode that) =>
      (that is ResultCode && this._value == that._value);

  String toString() => message(_value);
}
