# go-feedstock patches

## <a name="regenerate"></a>Regenerating the patches
The patches in this folder were created as follows:

    hub clone sodre/go
    cd go
    git checkout sodre/feedstock-go<major>.<minor>.<revision>
    git format-patch go<major>.<minor>.<revision> -o ..
    cd ..
    rm -rf go

Then each patch is added to the the patches section in meta.yaml.


## feedstock-go1.14.2
This branch is a rebase of the patches created for [feedstock-go1.13](#feedstock-go1.13.10).
Here are the steps we took to create it:

  1. Clone
  1. Define rebase helper function
     ```bash
     def go_feedstock_rebase()  {
       target_tag=$1
       source_tag=$2
       branch=$3
     
       git checkout -b ${branch}.${target_tag} sodre/${branch}.${source_tag}
       git rebase --onto ${target_tag} ${source_tag} ${branch}.${target_tag}
     }
     ```
  1. (🧠) `i-nocgo-issue10607` had a merge conflict
     ```shell script
     go_feedstock_rebase go1.14.2 go1.13.10 i-nocgo-issue10607
     # use 🧠 to solve merge conflict
     git push -u sodre i-nocgo-issue10607.go1.14.2
     ```
        
  1. (🥬) `i-conda-gfortran-tests` had no conflicts.
     We still kept our version.
     ```shell script
     go_feedstock_rebase go1.14.2 go1.13.10 i-conda-gfortran-tests
     git push -u sodre i-conda-gfortran-tests.go1.14.2
     ```
        
  1. (🥬) `f-conda-default-compiler-flags` had no conflicts.
     ```shell script
     go_feedstock_rebase go1.14.2 go1.13.10 f-conda-default-compiler-flags
     git push -u sodre f-conda-default-compiler-flags.go1.14.2
     ```
        
  1. (🧠🧠🧠) `f-conda-default-gobin-and-gopath` had merge conflicts.
     Upstream deleted a series of tests related to the GOBIN environment handling. 
     We kept our changes
     ```shell script
     go_feedstock_rebase go1.14.2 go1.13.10 f-conda-default-gobin-and-gopath
     # Use 🧠 to solve merge conflicts
     git push -u sodre f-conda-default-gobin-and-gopath.go1.14.2
     ```
     
  1. Create the feedstock-go1.14.2 branch
     ```shell script
     git checkout -b feedstock-go1.14.2 go1.14.2
     git merge --no-ff sodre/i-nocgo-issue10607.go1.14.2
     git merge --no-edit --no-ff sodre/i-conda-gfortran-tests.go1.14.2
     git merge --no-edit --no-ff sodre/f-conda-default-compiler-flags.go1.14.2
     git merge --no-edit --no-ff sodre/f-conda-default-gobin-and-gopath.go1.14.2
      
     git push -u sodre feedstock-go1.14.2
     ```

## <a name="feedstock-go1.13.10"></a>feedstock-go1.13.10
This branch is a rebase of the patches created for [feedstock-go1.12](#feedstock-go1.12).
Here are the steps we took to create it:

### Setup

  1. Clone both golang/go and add the sodre/go fork
        ```shell script
        hub clone golang/go
        cd go
        hub remote add sodre
        git fetch sodre
        ```

### Rebase all the branches onto 1.13.10
The next step is to rebase the 1.12.x patches onto 1.13.x.
The process is the same for each of the branches, the complications are the merge conflicts.
Solving the merge conflicts is a mix of 🎨 and 🔬.
We subjectively rated the rebase process from 🥬(easy) to  🧠🧠🧠(hard).
This scale is only valid within the 1.13.10 rebase process.

If you need push access to sodre/go's repository, please contact him.

  1.  (🥬) `i-nocgo-issue10607` had no conflicts
        ```shell script
        git checkout -b i-nocgo-issue10607.go1.13.10 sodre/i-nocgo-issue10607
        git rebase \
            --onto go1.13.10 go1.12.17 \
            i-nocgo-issue10607.go1.13   
        git push -u sodre i-nocgo-issue10607.go1.13.10
        ```
        
  1. (🧠) `i-conda-gfortran-tests` had merge conflicts 
      We still kept our version.
  
        ```shell script
        git checkout -b i-conda-gfortran-tests.go1.13 \
            sodre/i-conda-gfortran-tests.go1.12
        git rebase --onto go1.13.10 go1.12.17 \
                i-conda-gfortran-tests.go1.13.10
        # use 🧠 to solve merge conflicts
        git push -u sodre i-conda-gfortran-tests.go1.13.10
        ```
        
  1. (🧠🧠) `f-conda-default-compiler-flags` had merge conflicts.
      Upstream also started preserving additional environment variables when running their tests.
      It might be a good idea to ask upstream to merge the non-conda specific part of the patch as well.
      
        ```shell script
        git checkout -b f-conda-default-compiler-flags.go1.13.10 \
            sodre/f-conda-default-compiler-flags.go1.12    
        git rebase --onto go1.13.10 go1.12.17 \
            f-conda-default-compiler-flags.go1.13.10
        # Use 🧠 to solve merge conflicts
        git push -u sodre f-conda-default-compiler-flags.go1.13.10
        ```
        
  1. (🧠🧠🧠) `f-conda-default-gobin-and-gopath` had merge conflicts.
  
       ```shell script
        git checkout -b f-conda-default-gobin-and-gopath.go1.13.10 \
            sodre/f-conda-default-gobin-and-gopath.go1.12
        git rebase --onto go1.13.10 go1.12.17 \
            f-conda-default-gobin-and-gopath.go1.13.10
        # Use 🧠 to solve merge conflicts
        git push -u sodre f-conda-default-gobin-and-gopath.go1.13.10
        ```
     
### Create the feedstock-1.13.10 branch

    ```shell-script
    git checkout -b feedstock-go1.13.10 go1.13.10
    git merge --no-ff sodre/i-nocgo-issue10607.go1.13.10
    git merge --no-ff sodre/i-conda-gfortran-tests.go1.13.10
    git merge --no-ff sodre/f-conda-default-compiler-flags.go1.13.10
    git merge --no-ff sodre/f-conda-default-gobin-and-gopath.go1.13.10
    
    git push -u sodre feedstock-go1.13.10 
    ```

Regenerate the patches according to the [instructions](#regenerate)


    
## <a name="feedstock-go1.12"></a>feedstock-go1.12
The sodre/go?ref=feedstock-go1.12 branch was created by merging
the following individual branches:

  - i-nocgo-issue10607
  - f-conda-default-compiler-flags.go1.12
  - f-conda-default-gobin-and-gopath.go1.12
  - i-conda-gfortran-tests.go1.12

