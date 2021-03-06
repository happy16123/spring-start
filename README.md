# 정리
코드로 배우는 스프링 웹 프로젝트[^1]

## 1. 환경설정 및 파일수정
  - java 1.8, springframework 5.0.7, tomcat 9, Lombok, junit 4.12
  - bootstrap 오픈소스 사용(SB Admin 2)
  - maven-war-plugin 추가
  - xml을 사용하지 않기 때문에 AbstractAnnotationConfigDispatcherServletInitializer 상속받는 클래스 생성

## 2. 스프링의 주요 특징
  - POJO 기반의 구성
    - 일반적인 java 코드를 이용해 객체를 구성하는 방식 그대로 사용
    - 특정 라이브러리나 컨테이너 기술에 종속적이지 않다
  - 의존성 주입(DI)를 통한 객체 간의 관계 구성
    - 어떤 객체가 필요한 객체를 외부에서 밀어 넣는다
    - ApplicationContext가 필요한 객체를 생성하고, 주입하는 역할
    - ApplicationContext가 관리하는 객체들을 빈(Bean)이라고 함
    - 빈과 빈 사이의 의존관계를 처리하는 방식으로 xml, annotation, java 방식이 있다
  - AOP 지원
    - 반복코드를 줄이고 핵심 비즈니스 로직에만 집중할 수 있음
  - 편리한 MVC 구조
  - WAS의 종속적이지 않은 개발 환경

## 3. 의존성 주입 테스트
  - xml 설정
    - root-context.xml에서 객체를 설정하는 설정 파일
    - 파일 내 namespaces 탭에 context 항목 체크
  - java 설정
    - RootConfig로 만들어 놓은 클래스에 @ComponentScan 어노테이션을 이용해서 처리
  - lombok onMethod 사용시 jdk버전에 따라 차이가 있음
    - jdk7 : @Setter(onMethod = @__({@AnnotationsGoHere}))
    - jdk8 : @Setter(onMethod_ = {@AnnotationsgoHere})

### 3-1. 테스트 코드 작성
  - @ContextConfiguration
    - xml : root-context.xml 경로 지정
    - java : 클래스파일 지정
  1. 테스트코드가 실행되기 위해서 프레임워크가 동작
  2. 동작하는 과정에서 필요한 객체들이 스프링에 등록
  3. 의존성 주입이 필요한 객체는 자동으로 주입이 이루어짐

## 4. Database 연동
  - Oracle 설치 및 JDBC 연동
  - Mybatis 라이브러리 추가
  - Mapper는 SQL과 그에 대한 처리를 지정하는 역할
    - xml과 interface + annotation 형태로 작성 할 수 있음
    - @MapperScan을 이용해서 처리
  - xml 매퍼와 같이 쓰기
    - sql을 처리할 때 어노테이션을 이용하는 방식이 압도적으로 편리하지만 sql이 길어지거나 복잡할때에는 xml 방식을 선호하게 됨
    - xml 파일 위치와 xml 파일에 지정하는 namespace 속성이 중요
      1. Mapper 인터페이스가 있는 곳에 작성
      2. resources 구조에 폴더를 만들어 작성 
          - Mapper 인터페이스와 같은 이름을 이용하는 것이 좋음
          - 폴더를 하나씩 생성하는 것이 좋음. 한번에 만들면 제대로 인식이 안되는 문제가 발생
    - id 값은 메서드의 이름과 동일하게 작성
    - resultType 값은 인터페이스에 선언된 메소드의 리턴 타입과 동일하게 작성

### 4-1. log4jdbc 라이브러리 추가
  - PreparedStatement에 사용된 '?'가 어떤 값으로 처리되었는지 확인이 필요
  - 라이브러리 추가 후
    1. 로그설정 파일을 추가하는 작업
    2. JDBC연결 정보를 수정

## 5. MVC의 기본 구조
  - 프로젝트 구조
    - Spring MVC => servlet-context.xml, ServletConfig.class
    - Spring Core, MyBaits => root-context.xml, RootConfig.class
  - WebConfig : AbstractAnnotationConfigDispatcherServletInitalizer 상속
    - getrServletFilters 메소드 구현으로 한글 깨짐 설정(POST방식)
    - GET방식은 URL에 직접 데이터를 추가하여 전송하는 방식이기에 서블릿 영역 밖에 존재
      - 톰캣 server.xml에서 URIEncoding 설정
  - ServletConfig : @EnableWebMvc 어노테이션과 WebMvcConfigurer 인터페이스를 구현
    - WebMvcConfigurerAdapter 추상클래스는 5.0버전부터 Deprecated 되었음
  - 일반적은 웹 프로젝트는 3-tier 방식을 구성
    - Presentation(화면 계층)
      - 화면에 보여주는 기술을 사용하는 영역
      - Servlet/jsp나 스프링 MVC가 담당하는 영역
    - Business(비즈니스 계층)
      - 순수한 비즈니스 로직을 담고 있는 영역
      - 고객이 원하는 요구 사항을 반영하는 계층이기 때문에 중요함
      - 설계는 고객의 요구 사항과 정확히 일치해야함
      - 'xxxService'와 같은 이름으로 구성, 메소드 이름 역시 고객들이 사용하는 용어 그대로 사용하는 것이 좋음
    - Persistence(영속 계층 or 데이터 계층)
      - 데이터를 어떤 방식으로 보관하고 사용하는가에 대한 설계가 들어가있는 계층
      - 일반적으로 데이터베이스를 많이 사용하지만 경우에 따라 네트워크 호출, 원격 호출 등 기술이 접목될 수 있음
    - 각 영역별 Naming Convention(명명 규칙)
      - xxxController : 스프링 MVC에서 동작하는 Controller 클래스르 설계할 때 사용
      - xxxService, xxxServiceImpl : 비즈니스 영역을 담당하는 인터페이스와 구현한 클래스
      - xxxDAO, xxxRepository : DAO(Data Access Object)나 Repository라는 이름으로 영역을 따로 구성하는것이 보편적
      - VO, DTO
        - 일반적으로 유사한 의미로 데이터를 담고 있는 객체를 의미하는 공통점이 있음
        - VO : 주로 Read Only의 목적이 강하고 데이터도 Immutable(불변)하게 설계하는 것이 정석
        - DTO : 데이터 수집의 용도가 강함

### 5.1 Controller
  - HttpServletRequest, HttpServletResponse를 거의 사용할 필요 없이 필요한 기능 구현
  - 다양한 타입의 파라미터 처리, 다양한 타입의 리턴 타입 사용 가능
  - 전송 방식에 대한 처리를 어노테이션으로 처리 가능
  - 상속, 인터페이스 대신 어노테이션만으로도 필요한 설정 가능
  - @RequestMapping의 변화
    - 4.3버전부터는 @GetMapping, @PostMapping 축약형의 표현이 등장
    - GET, POST 뿐만아니라 PUT, DELETE 등 방식이 많이 사용됨(Restful)
  - 파라미터 수집
    - request.getParameter() 이용의 불폄함을 없애줌
    - @RequestParam 어노테이션으로 전달되는 파라미터를 받을 수 있음
    - 객체, 리스트, 배열 등 여러타입으로 받을수 있음
    - @InitBinder
      - 파라미터의 수집을 다른 용어로 'binding(바인딩)' 이라고 함
      - 변환이 가능한 데이터는 자동으로 되지만 파라미터를 변환해서 처리해야 하는 경우 @InitBinder를 사용
  - Return Type
    - String : jsp를 이용하는 경우에는 jsp 파일의 경로와 파일이름을 나타내기 위해 사용
    - void : 호출하는 URL과 동일한 이름의 jsp를 의미(메소드 이름)
    - VO, DTO : Json 타입의 데이터를 만들어서 반환하는 용도
    - ResponseEntity : response 할 때 Http 헤더 정보와 내용을 가공하는 용도
    - Model, ModelAndView : Model로 데이터를 반환하거나 화면까지 같이 지정하는 경우(최근에는 많이 사용하지 않음)
    - HttpHeaders : 응답에 내용 없이 Http 헤더 메시지만 전달하는 용도
  - 파일 업로드 처리
    - 전달되는 파일 데이터를 분석해야 하는데, Servlet 3.0 전까지는 commons의 파일 업로드를 이용하거나 cos.jar 등을 이용해 처리
    - Servlet 3.0 이후(Tomcat7.0)에는 기본적으로 업로드되는 파일을 처리할 수 있는 기능이 추가되어 있으므로 라이브러리가 필요하지 않음
  - Exception
    - @ExceptionHandler와 @ControllerAdvice를 이용한 처리
      - @ControllerAdvice는 AOP(Aspect-Oriented-Programming)를 이용하는 방식
      - AOP 방식을 이용하면 공통적인 예외사항에 대해 별도로 분리하는 방식
      - @ControllerAdvice : 해당 객체가 스프링의 컨트롤러에서 발생하는 예외를 처리하는 존재임을 명시하는 용도
      - @ExceptionHanlder : 해당 메서드가 들어가는 예외 타입을 처리한다는 것을 의미
        - 속성으로는 Exception 클래스 타입을 지정할 수 있음 ex) Exception.class
      - ServletConfig에서 인식해야 하므로 패키지를 추가해야함
    - @ResponseEntity를 이용하는 예외 메시지 구성
      - 404 에러 메시지는 적절하게 처리하는 것이 좋음
      - @ResponseStatus()를 사용해 not found일 때 적절한 페이지를 보여줌
      - Servlet 3.0 이상을 이용해야하며 WebConfig에 ServletRegistration.Dynamic 파라미터를 갖는 메소드를 작성해야함

### 5.2 Model
  - jsp(view)에 controller에서 생성되니 데이터를 담아서 전달하는 역할
  - Servlet : request.setAttribute()와 유사한 역할
  - Spring : model.addtribute()
  - @ModelAttribute
    - controller는 기본적으로 java bean 규칙에 맞는 개체는 다시 화면으로 객체를 전달함
      - 전달될 때에는 클래스명의 앞글자는 소문자로 처리
      - 기본 자료형일 경우는 파라미터로 선언하더라도 기본적으로 화면까지는 전달되지 않음
    - 강제로 전달받은 파라미터를 Model에 담아서 전달하도록 할 때 필요한 어노테이션
    - 타입에 관계없이 무조건 model에 담아서 전달되므로, 파라미터는 전달된 데이터를 다시 화면에서 사용해야 할 경우 유용하게 사용
  - RedirectAttributes
    - 일회셩으로 데이터를 전달하는 용도로 사용
    - Servlet : response.sendRedirect()와 동일한 용도
    - Spring : rttr.addFlashAttribute(); return "redirect:/";

### 6. Spring Security
  - 기본 동작 방식은 서블릿의 여러 종류의 필터와 인터셉터를 이용해 처리가 됨
  - 필터와 인터셉터는 특정한 서블릿이나 컨트롤러의 접근에 관여한다는 점에서는 유사하지만 필터는 스프링과 무관한 서블릿 자원이고, 인터셉터는 스프링의 빈으로 관리되면서 스프링 컨텍스트 내에 속함
  - 인터셉터의 경우 스프링의 내부에서 컨트롤러를 호출할 때 관여하기 때문에 스프링의 컨텍스트 내에 있는 모든 자원을 활용할 수 있음
  - CSRF(Cross-site request forgery)
    - 사이트 간 요청 위조
    - 사용자가 자신의 의지와는 무관하게 공격자가 의도한 행위를 특정 웹사이트에 요청하게 되는 공격

## Mybatis 정리
1. CDATA란?
  - 쿼리를 작성할 때, '<', '>', '&'를 사용해야하는 경우가 생기는데 xml에서 그냥 사용할 경우 태그로 인식하는 경우가 종종있다. 이럴경우 에러를 뱉어내기 때문에 '태그가 아니라 실제 쿼리에 필요한 코드'라고 
  알려줘야 한다. 그때 사용하는 것이 <!CDATA[...]]> 이다. 한 마디로 XML parser에 의해 해석하지말고 그대로 브라우저에 출력하라는 뜻이다.

2. 동적 SQL
  - <trim>
    - prefix 처리 후 엘리먼트의 내용이 있으면 가장 앞에 붙여준다.
    - prefixOverrides 처리 후 엘리먼트 내용 중 가장 앞에 해당 문자들이 있다면 자동으로 지워준다.
    - suffix 처리 후 엘리먼트 내에 내용이 있으면 가장 뒤에 붙여준다.
    - suffixOverrides 처리 후 엘리먼트 내용 중 가장 뒤에 해당 문자들이 있다면 자동으로 지워준다.

3. @Param
  - 원하는 명으로 mapper에서 사용할 수 있음
  - 어노테이션을 쓰지 않아도 mapper에서 #{param1}이라던지, #{parameter}로 파라미터 명을 적으면 사용이 가능

## REST(Representational State Transfer)
1. Annotation
  - @RestController : Controller가 REST 방식을 처리하기 위한 것임을 명시
  - @RespnseBody : 일반적인 jsp와 같은 뷰로 전달되는 게 아니라 데이터 자체를 전달하기 위한 용도
  - @PathVariable
    - URL 경로에 있는 값을 파라미터로 추출하려고 할 때 사용
    - URL에서 '{}'로 처리된 부분은 컨트롤러의 메소드에서 변수로 처리가 가능
  - @CroossOrigin : Ajax의 크로스 도메인 문제를 해결
  - @RequestBody : JSON데이터를 원하는 타입으로 바인딩 처리
  - @Consumes : 수신 하고자하는 데이터 포맷을 정의(받음)
  - @Produces : 출력 하고자하는 데이터 포맷을 정의(보냄)

2. ResponseEntity
  - REST 방식은 화면이 아니라 데이터를 전송하는 방식이기 때문에 요청한 쪽에서는 정상적인 데이터인지 구분할 수 있는 방법을 제공해야함
  - 데이터와 HTTP 헤더의 상태 메세지 등을 같이 전달하는 용도로 사용

3. 참고
  - REST방식으로 동작하는 URL을 설계할 때는 PK를 기준을 작성하는 것이 좋음
  - 브라우저나 외부에서 서버를 호출할 때 데이터의 포맷과 서버에서 보내주는 데이터의 타입을 명확히 설계해야 함

## jquery, javascript
  - jquery selector
    - $("#a") : id 값이 "a"인 요소
    - $(".a") : class가 "a"인 요소들
    - $("p") : <p>요소들
  - resources 파일 수정 시 js 파일 갱신이 안될 때가 있는데 ex) reply.js?ver=1로 해주면 캐시가 새로 생성되어 적용, 브라우저 다시 열기


## AOP(Aspect Oriented Programming)
  - 관점 지향 프로그래밍
  - 어떤 로직을 기준으로 핵심적인 관점, 부가적인 관점으로 나누어 보고 그 관점을 기준으로 각각 모듈화하겠다는 의미
    - 여기서 모듈화란 어떤 공통된 로직이나 기능을 하나의 단위로 묶는 것
  - 코드상에서 다른 부분에 계속 반복해서 쓰는 코드를 발견 할 수 있는데 이러한 현상을 흩어진 관심사(Crosscutting Concerns)라고 함
  - Target 
    - 순수한 비즈니스 로직을 의미, 어떠한 관심사들과도 관계를 맺지 않음(순수코어)
  - Proxy
    - Target을 전체적으로 감싸고 있는 존재
    - 내부적으로 Target을 호출하지만, 중간에 필요한 관심사들을 거쳐 Tartget을 호출하도록 자동 or 수동으로 작성
    - Proxy의 존재는 직접 코드를 통해 구현하는 경우도 있지만, 대부분의 경우 스프링 AOP기능을 이용해 자동으로 생성되는 방식을 이용(auto-proxy)
  - JoinPoint
    - Target 객체가 가진 메소드
    - 외부에서의 호출은 Proxy 객체를 통해 Tartget 객체의 JoinPoint를 호출하는 방식
    - Target이 가진 여러 메소드라고 보면 됨(엄밀하게 스프링 AOP에서는 메소드만이 JoinPoint가 됨)
    - Target에는 여러 메소드가 존재하기 때문에 어떤 메소드에 관심사를 결합할 것인지를 결정해야함(PointCut)
  - PointCut
    - 관심사와 비즈니스 로직이 결합되는 지점을 결정하는 것
    - Advice를 어떤 JoinPoint에 결합할 것인지를 결정하는 설정
    - JoinPoint의 상세한 스펙을 정의한 것, 구제적으로 Advice가 실행될 지점을 정할 수 있음
    - execution(@exectuion) : 메소드 기준으로 설정
      - execution([접근자제어패턴], 리턴타입패턴 [패키지패턴]메소드이름패턴(파라미터패턴)) [ ] 안의 패턴은 생략 가능
      - 각 패턴은 '*'를 이용하여 모든 값을 표현
      - '..'을 이용하여 0개 이상이라는 의미를 표현
    - within(@within) : 특정 타입(클래스)를 기준으로 설정
    - this : 주어진 인터페이스를 구현한 객체를 대상으로 설정
    - args(@args) : 특정 파라미터를 가지는 대상들만 설정
    - @annotation : 특정 어노테이션이 적용된 대상들만 설정
  - Aspect
    - 조금 추상적인 개념을 의미
    - 관심사 자체를 의미하는 추상명사
    - 흩어진 관심사를 모듈화 한 것, 주로 부가기능을 모듈화함
  - Advice 
    - Aspect를 구현한 코드
    - 실질적으로 어떤 일을 해야할지에 대한 것, 실질적인 부가기능을 담은 구현체
    - @Before
      - Target의 JoinPoint를 호출하기 전에 실행되는 코드
      - 코드 실행 자체에는 관여할 수 없음
    - @AfterReturning
      - 모든 실행이 정상적으로 이루어진 후에 동작하는 코드
    - @AfterThrowing
      - 예외가 발생한 뒤에 동작하는 코드
    - @After
      - 정상, 예외 구분 없이 실행되는 코드
    - @Around
      - 메소드의 실행 자체를 제어할 수 있는 가장 강력한 코드
      - 직접 대상 메소드를 호출하고 결과나 예외를 처리    