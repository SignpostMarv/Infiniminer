fetch:
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@if [ ! -f "/archive/infiniminer/repo.svndump.gz" ]; then wget -P /archive/infiniminer/ https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/infiniminer/repo.svndump.gz ; else echo "already fetched" ; fi
	@echo "5e164fbf7ffc1b92eff89dd9c010130c1c7fcea060dc769f0d2a83c5ca48b2e6f026dab7824b0caa7de3a86371c53a380b3ab663794939612c2de647eb0e23f0 */archive/infiniminer/repo.svndump.gz" | shasum -a 512 -b -c -
	@rm -fr /archive/infiniminer/svn/ /archive/infiniminer/svn-dump/
	@svnadmin create /archive/infiniminer/svn-dump/
	@gunzip -ck /archive/infiniminer/repo.svndump.gz | svnadmin load /archive/infiniminer/svn-dump/
	@svn checkout file:///archive/infiniminer/svn-dump/ /archive/infiniminer/svn/

svn2git--prep: fetch
	@svn log -v --xml --quiet /archive/infiniminer/svn/ | grep author | sort -u | perl -pe 's/.*>(.*?)<.*/\1 = /' > /archive/infiniminer/authors.txt
	@cat /app/archive-restore/users.txt | sed 's/=\s.*$//= /' > /archive/infiniminer/authors.tmp.txt
	@grep -Fvx -f /archive/infiniminer/authors.tmp.txt /archive/infiniminer/authors.txt | sed -E 's/(.+) = $$/\1 = \1 <\1@localhost>/' > /archive/infiniminer/authors2.tmp.txt
	@cat /app/archive-restore/users.txt /archive/infiniminer/authors2.tmp.txt > /archive/infiniminer/users.txt
	@rm /archive/infiniminer/authors*.txt

svn2git: svn2git--prep
	@rm -fr /archive/infiniminer/git/
	@git -c init.defaultBranch=${git_init_defaultbranch} svn clone file:///archive/infiniminer/svn-dump/ /archive/infiniminer/git/ \
		--authors-file=/archive/infiniminer/users.txt \
		--no-metadata \
		--stdlayout \
		--prefix "svn/"
	@cd /archive/infiniminer/git/ && \
		git branch -a | grep remotes/svn | grep -v trunk | sed -E 's/^.*remotes\/svn\///' | while read line; do git branch "svn/$$line" "remotes/svn/$$line"; done && \
		git branch -m svn/Marvulous%20Mod svn/Marvulous_Mod && \
		git branch -m svn/trunk
