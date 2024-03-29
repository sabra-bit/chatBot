question_answer('what is your name'   , 'I am a chat bot advisor for Eco-frindly Lifestyle ').
question_answer('who are you'   , 'I am a chat bot advisor for Eco-frindly Lifestyle ').
question_answer('hi'   , 'Hi, I am a chat bot advisor for Eco-frindly Lifestyle ').
question_answer('hello'   , 'Hello, I am a chat bot advisor for Eco-frindly Lifestyle ').



action('use reusable bags','environmentally').
action('turn off lights when not in use','environmentally'). 
action('compost food scraps','environmentally'). 
action('walk or bike short distances','environmentally'). 
action('use energy efficient appliances','environmentally').
action('turn off lights when not in use','energy_saving'). 
action('unplug electronics when not in use','energy_saving'). 
action('lower thermostat in winter','energy_saving'). 
action('raise thermostat in summer','energy_saving'). 
action('air dry clothes when possible','energy saving'). 
action('use reusable bags','sustainable'). 
action('compost food scraps','sustainable'). 
action('grow your own food','sustainable'). 
action('repair items instead of replacing','sustainable'). 
action('use water efficient appliances','sustainable'). 

dowhat(X, Actions) :-
  maplist(action(X), Actions).

%dowaht(X,A,B,C):- 
 %   action(X,A) ,action(X,B),action(X,C). 

text_to_list_of_words(Text, WordList) :-

    (   atom(Text)

    ->  atom_string(Text, String)

    ;   String = Text

    ),

    split_string(String, " ", "", WordList).
get_List(Input) :-
  % Add a newline for better formatting
  
  text_to_list_of_words(Input,X),nl,convert_to_downcase(X,Y),common_words(Y, ['sustainable', 'energy_saving','environmentally'],Words),nl,findall(Action,dowhat(Action,Words),R),write(R), nl.
get_List(Input,R) :-
  % Add a newline for better formatting
  
  text_to_list_of_words(Input,X),convert_to_downcase(X,Y),common_words(Y, ['sustainable', 'energy_saving','environmentally'],Words),findall(Action,dowhat(Action,Words),R),write(R).

writelist([]).

writelist([H|T]) :-

    write(H),

    (T \= [] -> write(' ') ; true),

    writelist(T).
common_words(List1, List2, Result) :-

    setof(X, (member(X, List1), member(X, List2)), Set1),

    setof(X, member(X, Set1), Result).
convert_to_downcase(List, DowncaseList) :-

    maplist(downcase_atom, List, DowncaseList).
main :-
   format(' \nHello, can i help you?  type help to get options~n',[]),
   read_line_to_codes(user_input,QCodes1),
   exclude(=(0'?),QCodes1,QCodes2),   
   atom_codes(QAtom1,QCodes2),
   downcase_atom(QAtom1,QAtom2),
   trim(QAtom2,TrimmedAtom),
   (
      question_answer(TrimmedAtom,Answer) 
      -> 
      format('~s~n',[Answer])
      ;
      QAtom2 = help -> format('~s~n',['the avable actions \n select topic: \n * sustainable\n * energy_saving\n * environmentally \n you can combine with action']),true;
	  %string_contains(QAtom2,'what') ->  format('~s~n',['testOK']),true;
      get_List(QAtom2),true;
   		

      format('~s~n',['Sorry, answer not found'])
   ),
   !,
   main.
string_contains(Haystack, Needle) :-

    sub_string(Haystack, _, _, _, Needle).
% That additional
% trim(Chars,TrimmedChars)

is_blank(X) :- 
   memberchk(X,[' ','\n','\r','\t']). % should be extended to the whole unicode "blank" class

trim(Atom,TrimmedAtom) :-
   atom_chars(Atom,Chars),
   trim_chars(Chars,TrimmedChars),
   atom_chars(TrimmedAtom,TrimmedChars).

trim_chars(Chars,TrimmedChars) :- 
   append([Prefix,TrimmedChars,Suffix],Chars),
   forall(member(X,Prefix),is_blank(X)),
   forall(member(X,Suffix),is_blank(X)),
   (
      TrimmedChars == [];
      (TrimmedChars = [First|_], \+is_blank(First), last(TrimmedChars,Last), \+is_blank(Last))
   ).