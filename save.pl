% == save.pl ==================================================================
%
% Save the Prolog state so it may be restarted "as is".
%
% Usage: ----------------------------------------------------------------------
%
% save(+NAME)
%   saves the current state as NAME in the BASE directory, with a
%   history of past versions.  Example values for NAME include 'prolog',
%   'cplint', 'logtalk', ...
%
% save
%   defaults to the last NAME used
%
% The BASE directory (defaults to /data) contains files for each saved
% state, with the date&time appended.  Additionally there are symbolic
% links of the form NAME-LATEST, NAME-PREVIOUS and just NAME, to the
% appropriate saved state file.
%
% Environment variables: ------------------------------------------------------
%
% SAVEDIR
%   where to put the saved states and links.
%
% @author Salvador Abreu <spa@debian.org>
% @license GPLv3

:- module(save, [save/0, save/1]).

:- use_module(library(charsio)).
:- use_module(library(filesex)).

:- dynamic saved/1.
:- dynamic prog/1.

save :- prog(PROG), !, save(PROG).
save :- save(prolog).

save(BASE) :-
    retractall(prog(_)),
    asserta(prog(BASE)),
    time_stamp(TIME),
    file_name(BASE, TIME, FILE),
    file_name(BASE, '-LATEST', FILE_LATEST),
    file_name(BASE, '-PREVIOUS', FILE_PREVIOUS),
%   file_name(FILE, '.log', FILE_L),
    save_dir(DIR),
    full_path(DIR, FILE, PATH),
    full_path(DIR, BASE, BASE_S),
%   full_path(DIR, FILE_L, FILE_LOG),
    OPTS = [ goal(( message, args, prolog)),
	     foreign(save),	% retain foreign libs in saved state
%	     map(FILE_LOG),	% debug information
	     verbose(false) ],
    full_path(DIR, FILE_LATEST, LATEST),
    full_path(DIR, FILE_PREVIOUS, PREVIOUS),
    retractall(saved(_)),
    asserta(saved(FILE)),
    qsave_program(PATH, OPTS),
    ( exists_file(BASE_S) -> true ; link_file(FILE_LATEST, BASE_S, symbolic) ),
    ( exists_file(LATEST) -> rename_file(LATEST, PREVIOUS) ; true ),
    link_file(FILE, LATEST, symbolic),
    write('saved '), message.


save_dir(DIR) :- getenv('SAVEDIR', DIR), !.
save_dir('/data').


time_stamp(STAMP) :-
    get_time(TIME),
    stamp_date_time(TIME, NOW, 'UTC'),
    NOW=date(YYYY, MM, DD, H, M, SS, _, _, _),
    S is floor(SS),
    T is 10000*H + 100*M + S,
    format_to_chars('-~|~`0t~d~4+.~`0t~d~3+.~`0t~d~3+-~`0t~d~7+',
		    [YYYY, MM, DD, T], STAMPS),
    name(STAMP, STAMPS).
    
file_name(BASE, STAMP, FILE) :-
    format_to_chars('~w~w', [BASE, STAMP], FILES),
    name(FILE, FILES).

full_path(DIR, FILE, PATH) :-
    format_to_chars('~w/~w', [DIR, FILE], PATHS),
    name(PATH, PATHS).

% -- say something ------------------------------------------------------------

message :-
    saved(VERSION), !,
    prog(PROG),
    format('docker.~s version 0.1 (~w)~n', [PROG, VERSION]).

message :-
    prog(PROG),
    format('docker.~s version 0.1~n', [PROG]).

% -----------------------------------------------------------------------------

args :-
    prolog_flag(argv, ARGS),
    args(ARGS).


args([]).
args(['-g', GS | ARGS]) :-
    read_term_from_atom(GS, G, []), call(G), !, 
    args(ARGS).
args([X | ARGS]) :-
    format('~s: unknown flag~n', [X]),
    args(ARGS).
