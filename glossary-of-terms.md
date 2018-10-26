# Glossary of Terms

<table>
  <thead>
    <tr>
      <th style="text-align:left"></th>
      <th style="text-align:left"></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">Library</td>
      <td style="text-align:left">A source file or collection of files designed to be imported into any
        program.</td>
    </tr>
    <tr>
      <td style="text-align:left">Module</td>
      <td style="text-align:left">A source file or collection of files that is part of a larger framework
        that may or may not be optional but depends in a large part on other modules
        within the framework.</td>
    </tr>
    <tr>
      <td style="text-align:left">Word</td>
      <td style="text-align:left">Forth's analog to functions.</td>
    </tr>
    <tr>
      <td style="text-align:left">Extension</td>
      <td style="text-align:left">A package that brings together several libraries and modules for a specific
        purpose and is designed to lay on top of a framework as an addition to
        it (i.e. extend it), as opposed to abstracting it.</td>
    </tr>
    <tr>
      <td style="text-align:left">Stack Effect or Stack Diagram</td>
      <td style="text-align:left">
        <p>The list of arguments and return values of a word. Here's a brief explanation
          of conventions used:</p>
        <p><code>( arg1 arg2 -- return1 return2 )</code>
        </p>
        <p><code>( xt -- ) ( adr -- ) </code>Second stack diagram describes the effect
          of the XT (or code), <em><b>or</b>, </em>in the case of defining words,
          describes what defined words do when called.</p>
        <p><code>( f: n -- f: n )</code> Floats</p>
        <p><code>( ... n -- n ... )</code> Unknown list of arguments which should
          be preserved by a callback</p>
        <p><code>( -- &lt;name&gt; )</code> Reads ahead in the input stream</p>
        <p><code>( -- &lt;code&gt; )</code> The code after the word is a parameter.
          (Similar to <code>does&gt;</code>)</p>
        <p><code>( n -- x|y )</code> Value may be one of two things.</p>
        <p><code>( n -- x y | a b )</code> Similar but with multiple returns.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"></td>
      <td style="text-align:left"></td>
    </tr>
    <tr>
      <td style="text-align:left"></td>
      <td style="text-align:left"></td>
    </tr>
    <tr>
      <td style="text-align:left"></td>
      <td style="text-align:left"></td>
    </tr>
    <tr>
      <td style="text-align:left"></td>
      <td style="text-align:left"></td>
    </tr>
  </tbody>
</table>