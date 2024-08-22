# Framework Structure - Technical Details

## ".warp" directory
The <b>/.warp</b> directory is the most important part of the frameworks because it contains all the core files:
<ol>  
    <li>  
        <span>/bin</span>  
        <p>Contains all the main files for the warp commands (<i>warp php [...], warp redis [...], warp mysql [...], etc.</i>)</p>  
    </li>  
    <li>  
        <span>/docker</span>  
        <p>This folder contains the <i>"/config"</i> directory where all the configurations selected at installation process are located and the <i>"volumes"</i> directory which is reserved for the actual docker images built with the correspondent data (Eg: MySQL container with the database)</p>  
    </li>  
    <li>  
        <span>/lib</span>  
        <p>Contains all the helper/action files to handle actions within the framework (<i>env.sh, log.sh, dockerhub.sh, etc.</i>)</p>  
        <p>  
            Within this folder there are 2 non-versioned files that are really important:  
            <ol>  
                <li><b>version.sh</b>: stores an environment variable with the current installed release (GitHub Tag. Eg: <i>2024.08.21</i>)</li>  
                <li><b>commit.sh</b>: stores an environment variable with the last commit of the current installed release</li>  
            </ol> 
            Both files are involved in the framework update by replacing their values with the ones matching the new release updated.  
        </p>  
    </li>  
    <li>  
        <span>/setup</span>  
        <p>Contains all the files involved in the installation setup wizard for framework initialization.</p>  
    </li>
    <li>
	<span><i>includes.sh</i> & <i>variables.sh</i></span>
	<p>Both files are core files and -as the name higlights- they include all the necessary files for the framework while the second one stores important variables accross the entire framework. </p>
	</li>
</ol>  

## Warp Binary
<p>This file is located at root level and its named "warp". This file contains some important functions regarding the installation/upgrade features but it's also in charge of handling every request by redirecting it to the correct bin file for its processing. Basically, it takes the $1 argument (<i>warp <b>php</b></i>) and redirects it to the right file (<i>bin/<b>php</b>.sh</i>).</p>   

<p>
This file should always be commited with the following mark at the end of the file:

```
 __ARCHIVE__
```  
For further details you can check the [deployment](deployment.md) section.
</p>